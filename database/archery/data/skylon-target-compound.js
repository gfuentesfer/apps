// Skylon Target/Hunting - Compound @ 301-340 FPS, release, 100gr
// Fuente: https://www.skylonarchery.com/images/chart/chart%20target.pdf

const ARROW_LENGTHS = [23, 24, 25, 26, 27, 28, 29, 30, 31, 32];

const ROWS = [
  { drawWeightMin: 29, drawWeightMax: 35, groups: ['A1', 'A2', 'A3', 'A4'] },
  { drawWeightMin: 35, drawWeightMax: 40, groups: ['A1', 'A2', 'A3', 'A4', 'A5'] },
  { drawWeightMin: 40, drawWeightMax: 45, groups: ['A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7'] },
  { drawWeightMin: 45, drawWeightMax: 50, groups: ['A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9'] },
  { drawWeightMin: 50, drawWeightMax: 55, groups: ['A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9', 'A10'] },
  { drawWeightMin: 55, drawWeightMax: 60, groups: ['A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9', 'A10'] },
  { drawWeightMin: 60, drawWeightMax: 65, groups: ['A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9', 'A10'] },
  { drawWeightMin: 65, drawWeightMax: 70, groups: ['A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9', 'A10', 'A11'] },
  { drawWeightMin: 70, drawWeightMax: 76, groups: ['A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9', 'A10', 'A11'] },
  { drawWeightMin: 76, drawWeightMax: 82, groups: ['A4', 'A5', 'A6', 'A7', 'A8', 'A9', 'A10', 'A11'] },
];

module.exports = {
  manufacturer: 'Skylon',
  chartName: 'Skylon Target - Compound 301-340 FPS',
  chartPurpose: 'TARGET',
  bowType: 'COMPOUND',
  shootingStyle: 'COMPOUND_RELEASE',
  version: '2024',
  publicationYear: 2024,
  referenceFpsMin: 301,
  referenceFpsMax: 340,
  referencePointGrains: 100,
  referenceReleaseType: 'MECHANICAL',
  sourceUrl: 'https://www.skylonarchery.com/images/chart/chart%20target.pdf',
  arrowLengths: ARROW_LENGTHS,
  rows: ROWS,
  valueType: 'skylon_group',
  skylonBowType: 'COMPOUND',
};
