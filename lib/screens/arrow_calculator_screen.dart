import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myarrowsapp/l10n/app_localizations.dart';

import '../models/arrow_recommendation.dart';
import '../models/catalog_models.dart';
import '../services/arrow_service.dart';
import '../utils/l10n_helpers.dart';

class ArrowCalculatorScreen extends StatefulWidget {
  const ArrowCalculatorScreen({super.key, this.arrowService});

  final ArrowService? arrowService;

  @override
  State<ArrowCalculatorScreen> createState() => _ArrowCalculatorScreenState();
}

class _ArrowCalculatorScreenState extends State<ArrowCalculatorScreen> {
  late final ArrowService _arrowService;
  final _formKey = GlobalKey<FormState>();

  final _drawWeightController = TextEditingController(text: '40');
  final _drawLengthController = TextEditingController(text: '28');

  bool _loadingCatalog = true;
  bool _calculating = false;
  String? _errorMessage;

  List<BowType> _bowTypes = [];
  List<ShootingStyle> _shootingStyles = [];
  List<Manufacturer> _manufacturers = [];
  List<ManufacturerChart> _charts = [];
  List<CompoundBowBrand> _compoundBowBrands = [];
  List<CompoundBowModel> _compoundBowModels = [];

  BowType? _selectedBowType;
  ShootingStyle? _selectedShootingStyle;
  Manufacturer? _selectedManufacturer;
  CompoundBowBrand? _selectedCompoundBowBrand;
  CompoundBowModel? _selectedCompoundBowModel;
  bool _fpsManuallyAdjusted = false;
  bool _fpsUnknown = true;
  int _speedFps = 320;

  ArrowRecommendationResult? _result;

  @override
  void initState() {
    super.initState();
    _arrowService = widget.arrowService ?? ArrowService();
    _loadCatalog();
  }

  @override
  void dispose() {
    _drawWeightController.dispose();
    _drawLengthController.dispose();
    super.dispose();
  }

  Future<void> _loadCatalog() async {
    setState(() {
      _loadingCatalog = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        _arrowService.fetchBowTypes(),
        _arrowService.fetchShootingStyles(),
        _arrowService.fetchManufacturers(),
        _arrowService.fetchCompoundBowBrands(),
      ]);

      if (!mounted) return;

      final bowTypes = results[0] as List<BowType>;
      final manufacturers = (results[2] as List<Manufacturer>)
          .where((m) => _hasChartsManufacturer(m.name))
          .toList();

      setState(() {
        _bowTypes = bowTypes;
        _shootingStyles = results[1] as List<ShootingStyle>;
        _manufacturers = manufacturers;
        _compoundBowBrands = results[3] as List<CompoundBowBrand>;
        _selectedBowType = bowTypes.firstWhere(
          (b) => b.code == 'COMPOUND',
          orElse: () => bowTypes.first,
        );
        _selectedManufacturer =
            manufacturers.isNotEmpty ? manufacturers.first : null;
        _loadingCatalog = false;
      });

      await _onBowTypeChanged(_selectedBowType);
      if (_selectedManufacturer != null) {
        await _onManufacturerChanged(_selectedManufacturer);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = '$e';
        _loadingCatalog = false;
      });
    }
  }

  bool _hasChartsManufacturer(String name) {
    return ['Easton', 'Victory', 'Skylon'].contains(name);
  }

  List<ShootingStyle> get _filteredStyles {
    if (_selectedBowType == null) return [];
    return _shootingStyles.where((s) {
      if (s.bowTypeId != _selectedBowType!.id) return false;
      // Los charts solo cubren compuesto con disparador, no con dedos.
      if (_selectedBowType!.code == 'COMPOUND' &&
          s.code == 'COMPOUND_FINGERS') {
        return false;
      }
      return true;
    }).toList();
  }

  ManufacturerChart? get _activeChart {
    if (_selectedBowType == null || _charts.isEmpty) return null;
    final bowCode = _selectedBowType!.code;
    final styleCode = _selectedShootingStyle?.code;

    final matches = _charts.where((c) {
      if (c.bowType != bowCode) return false;
      if (styleCode == null) return true;
      return c.shootingStyle == null || c.shootingStyle == styleCode;
    }).toList();

    return matches.isNotEmpty ? matches.first : null;
  }

  bool get _isCompound => _selectedBowType?.code == 'COMPOUND';

  void _syncFpsUnknownDefault() {
    _fpsUnknown = !_isCompound;
  }

  Future<void> _onBowTypeChanged(BowType? bowType) async {
    setState(() {
      _selectedBowType = bowType;
      final styles = _filteredStyles;
      _selectedShootingStyle = styles.isNotEmpty ? styles.first : null;
      if (!_isCompound) {
        _selectedCompoundBowBrand = null;
        _selectedCompoundBowModel = null;
        _compoundBowModels = [];
        _fpsManuallyAdjusted = false;
      }
      _syncFpsUnknownDefault();
      _result = null;
    });
    if (!_fpsUnknown) {
      _updateFpsFromChart();
    }
  }

  Future<void> _onCompoundBowBrandChanged(CompoundBowBrand? brand) async {
    setState(() {
      _selectedCompoundBowBrand = brand;
      _selectedCompoundBowModel = null;
      _compoundBowModels = [];
      _fpsManuallyAdjusted = false;
      _result = null;
    });

    if (brand == null) {
      _updateFpsFromChart();
      return;
    }

    try {
      final models =
          await _arrowService.fetchCompoundBowModels(brandId: brand.id);
      if (!mounted) return;
      setState(() => _compoundBowModels = models);
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = '$e');
    }
  }

  void _onCompoundBowModelChanged(CompoundBowModel? model) {
    setState(() {
      _selectedCompoundBowModel = model;
      _fpsManuallyAdjusted = false;
      _result = null;
      if (model != null && !_fpsUnknown) {
        _speedFps = model.iboFps;
      } else if (model == null && !_fpsUnknown) {
        _updateFpsFromChart();
      }
    });
  }

  Future<void> _onManufacturerChanged(Manufacturer? manufacturer) async {
    setState(() {
      _selectedManufacturer = manufacturer;
      _result = null;
    });

    if (manufacturer == null) {
      setState(() => _charts = []);
      return;
    }

    try {
      final charts =
          await _arrowService.fetchCharts(manufacturerId: manufacturer.id);
      if (!mounted) return;
      setState(() => _charts = charts);
      _updateFpsFromChart();
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = '$e');
    }
  }

  void _updateFpsFromChart() {
    if (_fpsUnknown || _selectedCompoundBowModel != null) return;
    final chart = _activeChart;
    if (chart?.referenceFpsMin != null && chart?.referenceFpsMax != null) {
      final mid =
          ((chart!.referenceFpsMin! + chart.referenceFpsMax!) / 2).round();
      setState(() => _speedFps = mid);
    }
  }

  Future<void> _calculate() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedManufacturer == null || _selectedBowType == null) return;

    setState(() {
      _calculating = true;
      _errorMessage = null;
      _result = null;
    });

    try {
      final result = await _arrowService.recommend(
        manufacturerId: _selectedManufacturer!.id,
        bowTypeId: _selectedBowType!.id,
        shootingStyleId: _selectedShootingStyle?.id,
        drawWeightLbs: double.parse(_drawWeightController.text),
        drawLengthInches: double.parse(_drawLengthController.text),
        speedFps: _fpsUnknown ? null : _speedFps,
      );

      if (!mounted) return;
      setState(() {
        _result = result;
        _calculating = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = '$e';
        _calculating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.arrowCalculator)),
      body: _loadingCatalog
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_errorMessage != null) ...[
                    Card(
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(_errorMessage!),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  _sectionTitle(context, l10n.yourBow),
                  if (_manufacturers.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(l10n.menuLoadError),
                      ),
                    )
                  else
                    DropdownButtonFormField<Manufacturer>(
                      value: _selectedManufacturer,
                    decoration: InputDecoration(
                      labelText: l10n.arrowBrand,
                      border: const OutlineInputBorder(),
                    ),
                    items: _manufacturers
                        .map(
                          (m) => DropdownMenuItem(
                            value: m,
                            child: Text(m.name),
                          ),
                        )
                        .toList(),
                    onChanged: _onManufacturerChanged,
                  ),
                  if (_bowTypes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<BowType>(
                    value: _selectedBowType,
                    decoration: InputDecoration(
                      labelText: l10n.bowType,
                      border: const OutlineInputBorder(),
                    ),
                    items: _bowTypes
                        .map(
                          (b) => DropdownMenuItem(
                            value: b,
                            child: Text(l10n.bowTypeLabel(b.code, b.description)),
                          ),
                        )
                        .toList(),
                    onChanged: _onBowTypeChanged,
                  ),
                  ],
                  if (_filteredStyles.length > 1) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<ShootingStyle>(
                      value: _selectedShootingStyle,
                      decoration: InputDecoration(
                        labelText: l10n.shootingStyle,
                        border: const OutlineInputBorder(),
                      ),
                      items: _filteredStyles
                          .map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text(
                                l10n.shootingStyleLabel(s.code, s.description),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() {
                        _selectedShootingStyle = value;
                        _result = null;
                        _updateFpsFromChart();
                      }),
                    ),
                  ],
                  if (_isCompound && _compoundBowBrands.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<CompoundBowBrand>(
                      value: _selectedCompoundBowBrand,
                      decoration: InputDecoration(
                        labelText: l10n.compoundBowBrand,
                        border: const OutlineInputBorder(),
                        helperText: l10n.compoundBowBrandHint,
                      ),
                      items: [
                        DropdownMenuItem<CompoundBowBrand>(
                          value: null,
                          child: Text(l10n.compoundBowManual),
                        ),
                        ..._compoundBowBrands.map(
                          (b) => DropdownMenuItem(
                            value: b,
                            child: Text(b.name),
                          ),
                        ),
                      ],
                      onChanged: _onCompoundBowBrandChanged,
                    ),
                    if (_selectedCompoundBowBrand != null &&
                        _compoundBowModels.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      DropdownButtonFormField<CompoundBowModel>(
                        value: _selectedCompoundBowModel,
                        decoration: InputDecoration(
                          labelText: l10n.compoundBowModel,
                          border: const OutlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem<CompoundBowModel>(
                            value: null,
                            child: Text(l10n.compoundBowSelectModel),
                          ),
                          ..._compoundBowModels.map(
                            (m) => DropdownMenuItem(
                              value: m,
                              child: Text(
                                '${m.displayLabel} — ${l10n.compoundBowIboFps(m.iboFps)}',
                              ),
                            ),
                          ),
                        ],
                        onChanged: _onCompoundBowModelChanged,
                      ),
                    ],
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _drawWeightController,
                          decoration: InputDecoration(
                            labelText: l10n.drawWeight,
                            border: const OutlineInputBorder(),
                            suffixText: 'lbs',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'),
                            ),
                          ],
                          validator: (v) {
                            if (v == null || v.isEmpty) return l10n.required;
                            final n = double.tryParse(v);
                            if (n == null || n < 10 || n > 100) {
                              return l10n.drawWeightRange;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _drawLengthController,
                          decoration: InputDecoration(
                            labelText: l10n.drawLength,
                            border: const OutlineInputBorder(),
                            suffixText: '"',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'),
                            ),
                          ],
                          validator: (v) {
                            if (v == null || v.isEmpty) return l10n.required;
                            final n = double.tryParse(v);
                            if (n == null || n < 20 || n > 34) {
                              return l10n.drawLengthRange;
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _sectionTitle(context, l10n.bowSpeedFps),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(l10n.fpsUnknown),
                    subtitle: Text(l10n.fpsUnknownHint),
                    value: _fpsUnknown,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _fpsUnknown = value;
                        _fpsManuallyAdjusted = false;
                        _result = null;
                      });
                      if (!value) {
                        if (_selectedCompoundBowModel != null) {
                          setState(() =>
                              _speedFps = _selectedCompoundBowModel!.iboFps);
                        } else {
                          _updateFpsFromChart();
                        }
                      }
                    },
                  ),
                  if (!_fpsUnknown) ...[
                  if (_selectedCompoundBowModel != null && !_fpsManuallyAdjusted)
                    Text(
                      l10n.fpsFromBowModel(
                        _selectedCompoundBowModel!.displayLabel,
                        _selectedCompoundBowModel!.iboFps,
                      ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    )
                  else if (_fpsManuallyAdjusted)
                    Text(
                      l10n.fpsManualOverride,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  else if (_activeChart != null)
                    Text(
                      l10n.chartLabel(_activeChart!.chartName),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '$_speedFps FPS',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (_activeChart?.referenceFpsMin != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            l10n.fpsReference(
                              _activeChart!.referenceFpsMin!,
                              _activeChart!.referenceFpsMax!,
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                    ],
                  ),
                  Slider(
                    value: _speedFps.toDouble(),
                    min: 250,
                    max: 360,
                    divisions: 110,
                    label: '$_speedFps FPS',
                    onChanged: (v) => setState(() {
                      _speedFps = v.round();
                      _fpsManuallyAdjusted = true;
                      _result = null;
                    }),
                  ),
                  ],
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: _calculating ? null : _calculate,
                    icon: _calculating
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.calculate),
                    label: Text(
                      _calculating ? l10n.calculating : l10n.calculateArrow,
                    ),
                  ),
                  if (_result != null) ...[
                    const SizedBox(height: 24),
                    _buildResults(context, l10n, _result!),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildResults(
    BuildContext context,
    AppLocalizations l10n,
    ArrowRecommendationResult result,
  ) {
    final primarySpine =
        result.spines.isNotEmpty ? result.spines.first : null;
    final rec = result.recommendations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle(context, l10n.recommendation),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _resultRow(
                  context,
                  Icons.straighten,
                  l10n.arrowLength,
                  '${rec.arrowLengthInches.toStringAsFixed(1)}"',
                  subtitle: l10n.drawLengthPlusOne,
                ),
                const Divider(height: 24),
                _resultRow(
                  context,
                  Icons.linear_scale,
                  l10n.spine,
                  primarySpine?.recommendedSpine ?? '—',
                  subtitle: primarySpine?.notes,
                ),
                const Divider(height: 24),
                _resultRow(
                  context,
                  Icons.circle,
                  l10n.recommendedPoint,
                  l10n.pointGrains(rec.pointWeightGrains),
                  subtitle: l10n.perChart(result.chartName),
                ),
                const Divider(height: 24),
                _resultRow(
                  context,
                  Icons.speed,
                  l10n.effectiveWeight,
                  '${result.effectiveDrawWeightLbs.toStringAsFixed(1)} lbs',
                  subtitle: _fpsUnknown
                      ? l10n.adjustedByPointOnly
                      : l10n.adjustedByFpsPoint,
                ),
              ],
            ),
          ),
        ),
        if (result.message != null) ...[
          const SizedBox(height: 8),
          Text(
            result.message!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        const SizedBox(height: 20),
        _sectionTitle(
          context,
          l10n.compatibleModels(result.arrows.length),
        ),
        if (result.arrows.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.noModelsForSpine),
            ),
          )
        else
          ...result.arrows.map((arrow) => _arrowCard(context, l10n, arrow)),
      ],
    );
  }

  Widget _resultRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    String? subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _arrowCard(
    BuildContext context,
    AppLocalizations l10n,
    CompatibleArrow arrow,
  ) {
    final description =
        l10n.arrowModelDescription(arrow.modelName, arrow.description);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              arrow.modelName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(description, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _chip(l10n.spineLabel(arrow.spineLabel ?? '${arrow.spine}')),
                if (arrow.arrowFamily != null) _chip(arrow.arrowFamily!),
                if (arrow.material != null) _chip(arrow.material!),
                if (arrow.gpi != null) _chip('${arrow.gpi} GPI'),
                if (arrow.shaftWeightGrains != null)
                  _chip(l10n.shaftWeight('${arrow.shaftWeightGrains}')),
                if (arrow.totalWeightGrains != null)
                  _chip(l10n.totalWeight('${arrow.totalWeightGrains}')),
                if (arrow.maxLengthInches != null)
                  _chip(l10n.maxLength('${arrow.maxLengthInches}')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
