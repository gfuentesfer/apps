// Easton Target Recurve Finger - PN 301055-A
// Fuente: Easton Target Arrow Shaft Selection Guide (recurve finger release)

const ARROW_LENGTHS = [23, 24, 25, 26, 27, 28, 29, 30, 31, 32];

const ROWS = [
  { drawWeightMin: 21, drawWeightMax: 27, groups: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'] },
  { drawWeightMin: 27, drawWeightMax: 32, groups: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9'] },
  { drawWeightMin: 32, drawWeightMax: 36, groups: ['T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11'] },
  { drawWeightMin: 36, drawWeightMax: 40, groups: ['T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12', 'T13'] },
  { drawWeightMin: 40, drawWeightMax: 44, groups: ['T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12', 'T13', 'T14'] },
  { drawWeightMin: 44, drawWeightMax: 48, groups: ['T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12', 'T13', 'T14'] },
  { drawWeightMin: 48, drawWeightMax: 52, groups: ['T7', 'T8', 'T9', 'T10', 'T11', 'T12', 'T13', 'T14'] },
  { drawWeightMin: 53, drawWeightMax: 57, groups: ['T8', 'T9', 'T10', 'T11', 'T12', 'T13', 'T14'] },
  { drawWeightMin: 58, drawWeightMax: 62, groups: ['T9', 'T10', 'T11', 'T12', 'T13', 'T14'] },
  { drawWeightMin: 63, drawWeightMax: 67, groups: ['T10', 'T11', 'T12', 'T13', 'T14'] },
  { drawWeightMin: 68, drawWeightMax: 73, groups: ['T11', 'T12', 'T13', 'T14'] },
];

// Recurvo bajo peso (grupos Y) - longitudes 21-27
const LOW_ROWS = [
  { drawWeightMin: 16, drawWeightMax: 20, arrowLengths: [21, 22, 23, 24, 25, 26, 27], groups: ['Y1', 'Y1', 'Y2', 'Y3', 'Y4'] },
  { drawWeightMin: 20, drawWeightMax: 24, arrowLengths: [21, 22, 23, 24, 25, 26, 27], groups: ['Y1', 'Y1', 'Y2', 'Y3', 'Y4', 'Y5'] },
  { drawWeightMin: 24, drawWeightMax: 28, arrowLengths: [21, 22, 23, 24, 25, 26, 27], groups: ['Y1', 'Y1', 'Y2', 'Y3', 'Y4', 'Y5', 'Y6'] },
  { drawWeightMin: 28, drawWeightMax: 32, arrowLengths: [21, 22, 23, 24, 25, 26, 27], groups: ['Y1', 'Y2', 'Y3', 'Y4', 'Y5', 'Y6', 'Y7'] },
  { drawWeightMin: 32, drawWeightMax: 36, arrowLengths: [22, 23, 24, 25, 26, 27], groups: ['Y2', 'Y3', 'Y4', 'Y5', 'Y6', 'Y7'] },
  { drawWeightMin: 36, drawWeightMax: 40, arrowLengths: [23, 24, 25, 26, 27], groups: ['Y3', 'Y4', 'Y5', 'Y6', 'Y7'] },
];

module.exports = {
  manufacturer: 'Easton',
  chartName: 'Easton Target - Recurve Finger',
  chartPurpose: 'TARGET',
  bowType: 'RECURVE',
  shootingStyle: 'OLYMPIC_RECURVE',
  version: '301055-A',
  publicationYear: 2024,
  referenceFpsMin: 301,
  referenceFpsMax: 320,
  referencePointGrains: 100,
  referenceReleaseType: 'FINGER',
  sourceUrl: 'https://goodarcher.com/wp-content/uploads/2024/09/Easton_Arrow_Shaft_Selection_Target.pdf',
  arrowLengths: ARROW_LENGTHS,
  rows: ROWS,
  lowPoundageRows: LOW_ROWS,
  valueType: 'group',
};
