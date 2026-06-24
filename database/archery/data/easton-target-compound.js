// Easton Target Compound Release - PN 301055-A
// Fuente: Easton Target Arrow Shaft Selection Guide (compound release aid section)

const ARROW_LENGTHS = [23, 24, 25, 26, 27, 28, 29, 30, 31, 32];

// Cada fila: peso compuesto (lbs) → grupos spine por longitud desde 23"
const ROWS = [
  { drawWeightMin: 29, drawWeightMax: 35, groups: ['00', '01', '02', '03', 'T1', 'T2', 'T3'] },
  { drawWeightMin: 35, drawWeightMax: 40, groups: ['01', '02', '03', 'T1', 'T2', 'T3', 'T4', 'T5'] },
  { drawWeightMin: 40, drawWeightMax: 45, groups: ['02', '03', 'T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'] },
  { drawWeightMin: 45, drawWeightMax: 50, groups: ['03', 'T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9'] },
  { drawWeightMin: 50, drawWeightMax: 55, groups: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10'] },
  { drawWeightMin: 55, drawWeightMax: 60, groups: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11'] },
  { drawWeightMin: 60, drawWeightMax: 65, groups: ['T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'] },
  { drawWeightMin: 65, drawWeightMax: 70, groups: ['T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12', 'T13'] },
  { drawWeightMin: 70, drawWeightMax: 76, groups: ['T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12', 'T13', 'T13'] },
];

module.exports = {
  manufacturer: 'Easton',
  chartName: 'Easton Target - Compound Release',
  chartPurpose: 'TARGET',
  bowType: 'COMPOUND',
  shootingStyle: 'COMPOUND_RELEASE',
  version: '301055-A',
  publicationYear: 2024,
  referenceFpsMin: 301,
  referenceFpsMax: 320,
  referencePointGrains: 100,
  referenceReleaseType: 'MECHANICAL',
  sourceUrl: 'https://goodarcher.com/wp-content/uploads/2024/09/Easton_Arrow_Shaft_Selection_Target.pdf',
  arrowLengths: ARROW_LENGTHS,
  rows: ROWS,
  valueType: 'group',
};
