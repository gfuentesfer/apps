// Victory VAP / VAP TKO - Compound @ 330 IBO FPS (+/-10), 100gr point
// Fuente: Victory VAP Selection Chart (Midway/Victory Archery)

const ARROW_LENGTHS = [21, 23, 24, 25, 26, 28, 29, 30, 31];

const ROWS = [
  { drawWeightMin: 14, drawWeightMax: 18, spines: [900, 800, 800, 800, 700, 700, 700, 600, 600] },
  { drawWeightMin: 19, drawWeightMax: 22, spines: [800, 800, 800, 700, 700, 700, 600, 600, 600] },
  { drawWeightMin: 23, drawWeightMax: 27, spines: [800, 700, 700, 700, 600, 600, 600, 500, 500] },
  { drawWeightMin: 28, drawWeightMax: 32, spines: [700, 700, 700, 600, 600, 600, 500, 500, 450] },
  { drawWeightMin: 33, drawWeightMax: 36, spines: [700, 700, 600, 600, 600, 500, 500, 450, 450] },
  { drawWeightMin: 37, drawWeightMax: 41, spines: [700, 600, 600, 600, 500, 500, 450, 450, 400] },
  { drawWeightMin: 42, drawWeightMax: 46, spines: [600, 600, 600, 500, 500, 450, 450, 400, 400] },
  { drawWeightMin: 47, drawWeightMax: 51, spines: [600, 600, 500, 500, 450, 450, 400, 400, 350] },
  { drawWeightMin: 52, drawWeightMax: 56, spines: [600, 500, 500, 500, 450, 400, 400, 350, 350] },
  { drawWeightMin: 57, drawWeightMax: 61, spines: [500, 500, 450, 450, 400, 400, 350, 350, 300] },
  { drawWeightMin: 62, drawWeightMax: 66, spines: [500, 450, 450, 400, 400, 350, 350, 300, 300] },
  { drawWeightMin: 67, drawWeightMax: 72, spines: [450, 450, 400, 400, 350, 350, 300, 300, 300] },
  { drawWeightMin: 73, drawWeightMax: 78, spines: [400, 400, 350, 350, 350, 300, 300, 300, 250] },
  { drawWeightMin: 79, drawWeightMax: 84, spines: [400, 350, 350, 350, 300, 300, 300, 250, 250] },
  { drawWeightMin: 85, drawWeightMax: 90, spines: [400, 350, 350, 300, 300, 300, 250, 250, 250] },
  { drawWeightMin: 90, drawWeightMax: 95, spines: [350, 350, 300, 300, 300, 250, 250, 250, 200] },
  { drawWeightMin: 95, drawWeightMax: 100, spines: [350, 300, 300, 300, 250, 250, 250, 200, 200] },
  { drawWeightMin: 100, drawWeightMax: 105, spines: [350, 300, 300, 250, 250, 250, 200, 200, 200] },
];

module.exports = {
  manufacturer: 'Victory',
  chartName: 'Victory VAP - Compound 330 FPS',
  chartPurpose: 'TARGET',
  bowType: 'COMPOUND',
  shootingStyle: 'COMPOUND_RELEASE',
  version: 'VAP-2024',
  publicationYear: 2024,
  referenceFpsMin: 320,
  referenceFpsMax: 340,
  referencePointGrains: 100,
  referenceReleaseType: 'MECHANICAL',
  sourceUrl: 'https://media.midwayusa.com/productdocuments/applicationchart/370/victory_vap_arrow_selection_chart.pdf',
  arrowLengths: ARROW_LENGTHS,
  rows: ROWS,
  valueType: 'spine',
};
