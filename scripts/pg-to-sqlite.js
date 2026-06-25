/** Adapta SQL escrito para PostgreSQL a SQLite (seeds e imports). */

const path = require('path');

function parseTupleValues(tuple) {
  const values = [];
  let i = 0;
  while (i < tuple.length) {
    while (i < tuple.length && /\s/.test(tuple[i])) i++;
    if (i >= tuple.length) break;

    if (tuple[i] === "'") {
      let j = i + 1;
      while (j < tuple.length) {
        if (tuple[j] === "'" && tuple[j + 1] === "'") j += 2;
        else if (tuple[j] === "'") break;
        else j++;
      }
      values.push(tuple.slice(i, j + 1));
      i = j + 1;
      if (tuple[i] === ',') i += 1;
      continue;
    }

    let j = i;
    while (j < tuple.length && tuple[j] !== ',') j++;
    values.push(tuple.slice(i, j).trim());
    i = j + 1;
  }
  return values;
}

function parseValueTuples(valuesContent) {
  const tuples = [];
  let i = 0;
  const s = valuesContent;
  while (i < s.length) {
    while (i < s.length && /[\s,]/.test(s[i])) i++;
    if (i >= s.length) break;
    if (s[i] !== '(') break;

    let depth = 0;
    const start = i;
    for (; i < s.length; i++) {
      if (s[i] === '(') depth++;
      else if (s[i] === ')') {
        depth--;
        if (depth === 0) {
          tuples.push(s.slice(start + 1, i));
          i++;
          break;
        }
      }
    }
  }
  return tuples;
}

function valuesBlockToUnion(valuesContent, columns) {
  const tuples = parseValueTuples(valuesContent);
  if (tuples.length === 0) return 'SELECT 1 WHERE 0';

  return tuples
    .map((tuple) => {
      const vals = parseTupleValues(tuple);
      const pairs = columns.map((col, idx) => `${vals[idx]} AS ${col}`);
      return `SELECT ${pairs.join(', ')}`;
    })
    .join('\nUNION ALL\n');
}

function convertValuesJoins(sql) {
  const pattern =
    /(CROSS JOIN|JOIN)\s+\(VALUES([\s\S]*?)\)\s+AS\s+(\w+)\(([^)]+)\)/gi;

  return sql.replace(pattern, (_match, joinType, valuesBlock, alias, colList) => {
    const columns = colList.split(',').map((c) => c.trim());
    const union = valuesBlockToUnion(valuesBlock, columns);
    if (joinType.toUpperCase() === 'CROSS JOIN') {
      return `JOIN (\n${union}\n) AS ${alias} ON 1=1`;
    }
    return `JOIN (\n${union}\n) AS ${alias}`;
  });
}

function adaptPgSql(sql) {
  let out = sql;

  out = out.replace(
    /CREATE\s+OR\s+REPLACE\s+(FUNCTION|VIEW)[\s\S]*?\$\$;?/gi,
    '',
  );

  // DISTINCT ON no existe en SQLite; esta tabla no usa la app en runtime.
  out = out.replace(
    /INSERT INTO chart_entry_arrow_model[\s\S]*?ORDER BY[\s\S]*?;/gi,
    '',
  );

  out = convertValuesJoins(out);

  out = out
    .replace(/\bBIGSERIAL\b/gi, 'INTEGER')
    .replace(/\bSERIAL\b/gi, 'INTEGER')
    .replace(/\bTIMESTAMPTZ\b/gi, 'TEXT')
    .replace(/\bBOOLEAN\b/gi, 'INTEGER')
    .replace(/\bNOW\(\)/gi, "datetime('now')")
    .replace(/\bTRUE\b/g, '1')
    .replace(/\bFALSE\b/g, '0')
    .replace(/::\w+/g, '')
    .replace(/\bILIKE\b/gi, 'LIKE');

  return out;
}

function prepareSeedContent(filePath, sql) {
  const base = path.basename(filePath);
  if (base === '10_compound_bow_catalog.sql') {
    const marker = '-- Marcas principales';
    const idx = sql.indexOf(marker);
    if (idx >= 0) return sql.slice(idx);
  }
  if (base === '07_spine_group_lookup.sql') {
    const marker = '-- Reglas Victory';
    const idx = sql.indexOf(marker);
    if (idx >= 0) return sql.slice(idx);
  }
  return sql;
}

function execSqlFile(db, sql, filePath) {
  const prepared = filePath ? prepareSeedContent(filePath, sql) : sql;
  const adapted = adaptPgSql(prepared);
  db.exec(adapted);
}

module.exports = {
  adaptPgSql,
  execSqlFile,
  convertValuesJoins,
  parseTupleValues,
  parseValueTuples,
};
