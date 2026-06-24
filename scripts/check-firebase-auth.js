#!/usr/bin/env node
/**
 * Comprueba si Firebase Authentication está inicializado en el proyecto.
 * Uso: node scripts/check-firebase-auth.js
 */
const fs = require('fs');
const path = require('path');
const os = require('os');

const projectId = 'myarrowsapp';
const configPath = path.join(os.homedir(), '.config', 'configstore', 'firebase-tools.json');

async function main() {
  if (!fs.existsSync(configPath)) {
    console.error('No hay sesión de Firebase CLI. Ejecuta: firebase login');
    process.exit(1);
  }

  const cfg = JSON.parse(fs.readFileSync(configPath, 'utf8'));
  const token = cfg.tokens?.access_token;
  if (!token) {
    console.error('Token de Firebase CLI no encontrado. Ejecuta: firebase login');
    process.exit(1);
  }

  const url = `https://identitytoolkit.googleapis.com/admin/v2/projects/${projectId}/config`;
  const res = await fetch(url, { headers: { Authorization: `Bearer ${token}` } });
  const data = await res.json();

  if (data.error?.message === 'CONFIGURATION_NOT_FOUND') {
    console.log('❌ Authentication NO está configurado en Firebase.');
    console.log('');
    console.log('Pasos:');
    console.log(`  1. Abre https://console.firebase.google.com/project/${projectId}/authentication`);
    console.log('  2. Pulsa "Comenzar" / "Get started"');
    console.log('  3. En "Sign-in method" activa "Correo electrónico/Contraseña"');
    console.log('  4. Vuelve a ejecutar la app (flutter run)');
    process.exit(1);
  }

  if (data.error) {
    console.error('Error:', data.error.message);
    process.exit(1);
  }

  const emailEnabled = data.signIn?.email?.enabled === true;
  console.log(`✓ Authentication configurado. Email/Password: ${emailEnabled ? 'activado' : 'DESACTIVADO'}`);
  if (!emailEnabled) {
    console.log(`  → Actívalo en https://console.firebase.google.com/project/${projectId}/authentication/providers`);
    process.exit(1);
  }
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
