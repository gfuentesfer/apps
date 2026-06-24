// Grupos Skylon A1-A13 → spine recomendado por tipo (R=recurvo, C=compuesto)
// Fuente: https://www.skylonarchery.com/images/chart/chart%20target.pdf
//         https://www.skylonarchery.com/images/chart/chart%20hunting.pdf

const RECURVE = {
  A1: { min: 1000, max: 1000, models: 'Brixxon' },
  A2: { min: 900, max: 850, models: 'Brixxon' },
  A3: { min: 850, max: 800, models: 'Brixxon' },
  A4: { min: 750, max: 700, models: 'Brixxon' },
  A5: { min: 700, max: 650, models: 'Brixxon' },
  A6: { min: 600, max: 550, models: 'Brixxon' },
  A7: { min: 550, max: 500, models: 'Brixxon' },
  A8: { min: 500, max: 500, models: 'Brixxon' },
  A9: { min: 450, max: 450, models: 'Brixxon' },
  A10: { min: 400, max: 400, models: 'Brixxon' },
  A11: { min: 1100, max: 1100, models: 'Brixxon' },
  A12: { min: 1000, max: 1000, models: 'Paragon' },
  A13: { min: 600, max: 550, models: 'Performa/Preminens/Paragon' },
};

const COMPOUND = {
  A1: { min: 800, max: 800, models: 'Bentwood/Edge/Frontier' },
  A2: { min: 800, max: 700, models: 'Bentwood/Edge/Frontier' },
  A3: { min: 700, max: 700, models: 'Bentwood/Edge/Frontier' },
  A4: { min: 600, max: 500, models: 'Bentwood/Edge/Frontier' },
  A5: { min: 500, max: 500, models: 'Bentwood/Edge/Frontier' },
  A6: { min: 500, max: 400, models: 'Bentwood/Edge/Frontier/Maverick/Rove/Savage' },
  A7: { min: 400, max: 400, models: 'Bentwood/Edge/Frontier/Maverick/Rove/Savage' },
  A8: { min: 400, max: 350, models: 'Maverick/Rove/Savage' },
  A9: { min: 350, max: 350, models: 'Bentwood/Edge/Maverick/Frontier/Rove' },
  A10: { min: 350, max: 300, models: 'Edge/Maverick/Frontier/Rove' },
  A11: { min: 300, max: 300, models: 'Edge/Maverick/Rove' },
  A12: { min: 300, max: 300, models: 'Empros' },
  A13: { min: 300, max: 300, models: 'Empros' },
};

function normalizeGroup(code) {
  if (!code) return null;
  return String(code)
    .replace(/Al/g, 'A1')
    .replace(/ATl/g, 'A11')
    .replace(/A1D/g, 'A10')
    .replace(/All/g, 'A11')
    .replace(/Am/g, 'A11')
    .replace(/[^A0-9]/gi, '')
    .toUpperCase();
}

const LOW_POUNDAGE = {
  Y1: { min: 2000, max: 2000, models: 'Radius' },
  Y2: { min: 1800, max: 1800, models: 'Radius' },
  Y3: { min: 1600, max: 1600, models: 'Radius' },
  Y4: { min: 1400, max: 1400, models: 'Radius' },
  Y5: { min: 1200, max: 1200, models: 'Radius' },
  Y6: { min: 1100, max: 1100, models: 'Brixxon' },
};

function parseSkylonGroup(code, bowType = 'RECURVE') {
  const group = normalizeGroup(code);
  const low = LOW_POUNDAGE[group];
  if (low) {
    return {
      recommended: group,
      min: low.min,
      max: low.max,
      groupCode: group,
      models: low.models,
    };
  }
  const table = bowType === 'COMPOUND' ? COMPOUND : RECURVE;
  const entry = table[group];
  if (!entry) {
    return { recommended: group, min: null, max: null, groupCode: group };
  }
  return {
    recommended: group,
    min: entry.min,
    max: entry.max,
    groupCode: group,
    models: entry.models,
  };
}

module.exports = { RECURVE, COMPOUND, parseSkylonGroup, normalizeGroup };
