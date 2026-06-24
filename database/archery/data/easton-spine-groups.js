// Mapeo grupos Easton → spine numérico (static spine × 1000 o rango)
// Fuente: Easton Target Shaft Selection Guide PN 301055-A

module.exports.EASTON_SPINE_GROUPS = {
  Y1: { min: 2000, max: 2000, label: 'Y1' },
  Y2: { min: 1800, max: 1800, label: 'Y2' },
  Y3: { min: 1600, max: 1600, label: 'Y3' },
  Y4: { min: 1416, max: 1416, label: 'Y4' },
  Y5: { min: 1250, max: 1300, label: 'Y5' },
  Y6: { min: 1150, max: 1200, label: 'Y6' },
  Y7: { min: 1000, max: 1070, label: 'Y7' },
  '00': { min: 1800, max: 1800, label: '00' },
  '01': { min: 1500, max: 1600, label: '01' },
  '02': { min: 1250, max: 1300, label: '02' },
  '03': { min: 1100, max: 1150, label: '03' },
  T1: { min: 920, max: 1000, label: 'T1' },
  T2: { min: 880, max: 1000, label: 'T2' },
  T3: { min: 780, max: 850, label: 'T3' },
  T4: { min: 750, max: 830, label: 'T4' },
  T5: { min: 720, max: 780, label: 'T5' },
  T6: { min: 670, max: 720, label: 'T6' },
  T7: { min: 620, max: 670, label: 'T7' },
  T8: { min: 570, max: 620, label: 'T8' },
  T9: { min: 520, max: 570, label: 'T9' },
  T10: { min: 470, max: 520, label: 'T10' },
  T11: { min: 430, max: 470, label: 'T11' },
  T12: { min: 400, max: 430, label: 'T12' },
  T13: { min: 370, max: 400, label: 'T13' },
  T14: { min: 270, max: 325, label: 'T14' },
};

module.exports.parseSpineRange = (value) => {
  if (!value || value === '-') return null;
  const str = String(value).trim();
  if (module.exports.EASTON_SPINE_GROUPS[str]) {
    const g = module.exports.EASTON_SPINE_GROUPS[str];
    return { recommended: str, min: g.min, max: g.max, groupCode: str };
  }
  const rangeMatch = str.match(/^(\d+)\s*[-–]\s*(\d+)$/);
  if (rangeMatch) {
    return {
      recommended: str,
      min: Number(rangeMatch[2]),
      max: Number(rangeMatch[1]),
      groupCode: null,
    };
  }
  const num = Number(str);
  if (!Number.isNaN(num)) {
    return { recommended: str, min: num, max: num, groupCode: null };
  }
  return { recommended: str, min: null, max: null, groupCode: str };
};
