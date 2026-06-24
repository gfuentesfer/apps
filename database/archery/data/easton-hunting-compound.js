// Easton Hunting Compound - PN 301055-A (301-340 FPS, release, 100gr)
// Fuente: https://eastonarchery.com/wp-content/uploads/2023/08/301055-A-Arrow-Shaft-Selection-Hunting.pdf

const ARROW_LENGTHS = [23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34];

const ROWS = [
  { drawWeightMin: 22, drawWeightMax: 26, spines: [null, null, null, '700-600', '700-600', '600-500', '600-500', '500-400', '500-400', '500-400', '400-350', '400-350'] },
  { drawWeightMin: 27, drawWeightMax: 31, spines: [null, null, '700-600', '700-600', '600-500', '600-500', '500-400', '500-400', '500-400', '400-350', '400-350', '400-350'] },
  { drawWeightMin: 32, drawWeightMax: 36, spines: [null, '700-600', '700-600', '600-500', '600-500', '500-400', '500-400', '500-400', '400-350', '400-350', '400-350', '350-300'] },
  { drawWeightMin: 37, drawWeightMax: 41, spines: ['700-600', '700-600', '600-500', '600-500', '500-400', '500-400', '500-400', '400-350', '400-350', '400-350', '350-300', '350-300'] },
  { drawWeightMin: 42, drawWeightMax: 46, spines: ['700-600', '600-500', '600-500', '500-400', '500-400', '500-400', '400-350', '400-350', '400-350', '350-300', '350-300', '350-300'] },
  { drawWeightMin: 47, drawWeightMax: 51, spines: ['600-500', '600-500', '500-400', '500-400', '500-400', '400-350', '400-350', '400-350', '350-300', '350-300', '350-300', '300-250'] },
  { drawWeightMin: 52, drawWeightMax: 56, spines: ['600-500', '500-400', '500-400', '500-400', '400-350', '400-350', '400-350', '350-300', '350-300', '350-300', '300-250', '300-250'] },
  { drawWeightMin: 57, drawWeightMax: 61, spines: ['500-400', '500-400', '500-400', '400-350', '400-350', '400-350', '350-300', '350-300', '350-300', '300-250', '300-250', '300-250'] },
  { drawWeightMin: 62, drawWeightMax: 66, spines: ['500-400', '500-400', '400-350', '400-350', '400-350', '350-300', '350-300', '350-300', '300-250', '300-250', '300-250', '250-200'] },
  { drawWeightMin: 67, drawWeightMax: 72, spines: ['500-400', '400-350', '400-350', '400-350', '350-300', '350-300', '350-300', '300-250', '300-250', '300-250', '250-200', '250-200'] },
  { drawWeightMin: 73, drawWeightMax: 78, spines: ['400-350', '400-350', '400-350', '350-300', '350-300', '350-300', '300-250', '300-250', '300-250', '250-200', '250-200', '250-200'] },
  { drawWeightMin: 79, drawWeightMax: 84, spines: ['400-350', '400-350', '350-300', '350-300', '350-300', '300-250', '300-250', '300-250', '250-200', '250-200', '200-150', '200-150'] },
  { drawWeightMin: 85, drawWeightMax: 90, spines: ['400-350', '350-300', '350-300', '350-300', '300-250', '300-250', '300-250', '250-200', '250-200', '200-150', '200-150', '200-150'] },
];

module.exports = {
  manufacturer: 'Easton',
  chartName: 'Easton Hunting - Compound Release',
  chartPurpose: 'HUNTING',
  bowType: 'COMPOUND',
  shootingStyle: 'COMPOUND_RELEASE',
  version: '301055-A',
  publicationYear: 2023,
  referenceFpsMin: 301,
  referenceFpsMax: 340,
  referencePointGrains: 100,
  referenceReleaseType: 'MECHANICAL',
  sourceUrl: 'https://eastonarchery.com/wp-content/uploads/2023/08/301055-A-Arrow-Shaft-Selection-Hunting.pdf',
  arrowLengths: ARROW_LENGTHS,
  rows: ROWS,
};
