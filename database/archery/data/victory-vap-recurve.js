// Victory VAP / VAP TKO - Recurve @ 330 IBO FPS (+/-10), 100gr point
// Fuente: Victory VAP Selection Chart (Midway/Victory Archery)

const ARROW_LENGTHS = [21, 23, 24, 25, 26, 28, 29, 30, 31];

const ROWS = [
  { drawWeightMin: 10, drawWeightMax: 14, spines: [1000, 1000, 1000, 900, 900, 900, 800, 800, 800] },
  { drawWeightMin: 15, drawWeightMax: 19, spines: [1000, 1000, 900, 900, 900, 800, 800, 800, 700] },
  { drawWeightMin: 20, drawWeightMax: 24, spines: [1000, 900, 900, 900, 800, 800, 800, 700, 700] },
  { drawWeightMin: 25, drawWeightMax: 29, spines: [900, 900, 800, 800, 800, 700, 700, 700, 600] },
  { drawWeightMin: 30, drawWeightMax: 34, spines: [800, 800, 800, 700, 700, 700, 600, 600, 600] },
  { drawWeightMin: 35, drawWeightMax: 39, spines: [800, 700, 700, 700, 600, 600, 600, 500, 500] },
  { drawWeightMin: 40, drawWeightMax: 44, spines: [700, 700, 600, 600, 600, 500, 500, 500, 450] },
  { drawWeightMin: 45, drawWeightMax: 49, spines: [600, 600, 500, 500, 500, 450, 450, 400, 400] },
  { drawWeightMin: 50, drawWeightMax: 54, spines: [600, 500, 500, 500, 450, 450, 400, 400, 350] },
  { drawWeightMin: 55, drawWeightMax: 59, spines: [500, 500, 450, 450, 400, 400, 350, 350, 300] },
  { drawWeightMin: 60, drawWeightMax: 64, spines: [500, 450, 450, 400, 400, 350, 350, 300, 300] },
  { drawWeightMin: 65, drawWeightMax: 69, spines: [450, 450, 400, 400, 350, 350, 300, 300, 250] },
  { drawWeightMin: 70, drawWeightMax: 74, spines: [400, 400, 350, 350, 300, 300, 250, 250, 250] },
];

module.exports = {
  manufacturer: 'Victory',
  chartName: 'Victory VAP - Recurve 330 FPS',
  chartPurpose: 'TARGET',
  bowType: 'RECURVE',
  shootingStyle: 'OLYMPIC_RECURVE',
  version: 'VAP-2024',
  publicationYear: 2024,
  referenceFpsMin: 320,
  referenceFpsMax: 340,
  referencePointGrains: 100,
  referenceReleaseType: 'FINGER',
  sourceUrl: 'https://media.midwayusa.com/productdocuments/applicationchart/370/victory_vap_arrow_selection_chart.pdf',
  arrowLengths: ARROW_LENGTHS,
  rows: ROWS,
  valueType: 'spine',
};
