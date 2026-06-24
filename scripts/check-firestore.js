#!/usr/bin/env node
/**
 * Comprueba si Firestore está disponible en el proyecto.
 * Uso: node scripts/check-firestore.js
 */
const fs = require('fs');
const path = require('path');
const os = require('os');

const projectId = 'myarrowsapp';
const configPath = path.join(os.homedir(), '.config', 'configstore', 'firebase-tools.json');

async function main() {
  if (!fs.existsSync(configPath)) {
    console.error('Ejecuta primero: firebase login');
    process.exit(1);
  }

  const cfg = JSON.parse(fs.readFileSync(configPath, 'utf8'));
  const token = cfg.tokens?.access_token;
  if (!token) {
    console.error('Token no encontrado. Ejecuta: firebase login');
    process.exit(1);
  }

  const enableUrl = `https://serviceusage.googleapis.com/v1/projects/${projectId}/services/firestore.googleapis.com`;
  const enableRes = await fetch(enableUrl, {
    headers: { Authorization: `Bearer ${token}` },
  });
  const enableData = await enableRes.json();
  const apiEnabled = enableData.state === 'ENABLED';

  console.log(`API Firestore: ${apiEnabled ? 'activada' : 'no activada o pendiente'}`);

  const dbUrl = `https://firestore.googleapis.com/v1/projects/${projectId}/databases/(default)/documents/users/test-probe`;
  const dbRes = await fetch(dbUrl, {
    headers: { Authorization: `Bearer ${token}` },
  });

  if (dbRes.status === 404 || dbRes.status === 403) {
    const body = await dbRes.text();
    if (body.includes('has not been used') || body.includes('NOT_FOUND')) {
      console.log('❌ Base de datos Firestore NO creada todavía.');
      console.log('');
      console.log('Pasos en la consola:');
      console.log(`  1. https://console.firebase.google.com/project/${projectId}/firestore`);
      console.log('  2. Pulsa "Crear base de datos"');
      console.log('  3. Modo: Producción (luego desplegamos reglas)');
      console.log('  4. Ubicación: eur3 (Europa) o la más cercana');
      console.log('  5. Espera 1-2 min y ejecuta: firebase deploy --only firestore:rules');
      process.exit(1);
    }
  }

  if (apiEnabled) {
    console.log('✓ Firestore parece configurado. Si la app falla, despliega reglas:');
    console.log('  firebase deploy --only firestore:rules');
  }
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
