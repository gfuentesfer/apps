// Skylon Target/Hunting - Recurve @ 301-340 FPS, dedos, 100gr
// Fuente: https://www.skylonarchery.com/images/chart/chart%20hunting.pdf

const ARROW_LENGTHS = [23, 24, 25, 26, 27, 28, 29, 30, 31, 32];

const ROWS = [
  { drawWeightMin: 20, drawWeightMax: 23, groups: ['A1', 'A2', 'A3', 'A4'] },
  { drawWeightMin: 24, drawWeightMax: 29, groups: ['A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9', 'A10'] },
  { drawWeightMin: 30, drawWeightMax: 35, groups: ['A1', 'A2', 'A3', 'A4', 'A5'] },
  { drawWeightMin: 36, drawWeightMax: 40, groups: ['A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7'] },
  { drawWeightMin: 41, drawWeightMax: 45, groups: ['A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8'] },
  { drawWeightMin: 46, drawWeightMax: 50, groups: ['A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9'] },
  { drawWeightMin: 51, drawWeightMax: 55, groups: ['A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9', 'A10'] },
  { drawWeightMin: 56, drawWeightMax: 60, groups: ['A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9', 'A10', 'A11'] },
  { drawWeightMin: 61, drawWeightMax: 65, groups: ['A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9', 'A10', 'A11', 'A12'] },
  { drawWeightMin: 66, drawWeightMax: 70, groups: ['A4', 'A5', 'A6', 'A7', 'A8', 'A9', 'A10', 'A11', 'A12', 'A13'] },
];

// Bajo peso (grupos GR Y / Radius)
const LOW_ROWS = [
  { drawWeightMin: 10, drawWeightMax: 16, arrowLengths: [23, 24, 25, 26, 27], groups: ['GR Y1', 'GR Y1', 'GR Y2', 'GR Y3', 'GR Y4'] },
  { drawWeightMin: 16, drawWeightMax: 20, arrowLengths: [23, 24, 25, 26, 27, 28], groups: ['GR Y1', 'GR Y2', 'GR Y3', 'GR Y4', 'GR Y5', 'GR Y6'] },
  { drawWeightMin: 20, drawWeightMax: 24, arrowLengths: [24, 25, 26, 27, 28], groups: ['GR Y2', 'GR Y3', 'GR Y4', 'GR Y5', 'GR Y6'] },
];

module.exports = {
  manufacturer: 'Skylon',
  chartName: 'Skylon Target - Recurve 301-340 FPS',
  chartPurpose: 'TARGET',
  bowType: 'RECURVE',
  shootingStyle: 'OLYMPIC_RECURVE',
  version: '2024',
  publicationYear: 2024,
  referenceFpsMin: 301,
  referenceFpsMax: 340,
  referencePointGrains: 100,
  referenceReleaseType: 'FINGER',
  sourceUrl: 'https://www.skylonarchery.com/images/chart/chart%20hunting.pdf',
  arrowLengths: ARROW_LENGTHS,
  rows: ROWS,
  lowPoundageRows: LOW_ROWS,
  valueType: 'skylon_group',
  skylonBowType: 'RECURVE',
};
