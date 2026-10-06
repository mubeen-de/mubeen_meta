const { execSync, spawnSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const projectRoot = path.resolve(__dirname, '..');
const parentDir = path.resolve(projectRoot, '..');

console.log('=======================================================================');
console.log('           PETPOOJA / KAPMETA PACKAGING UTILITY (ZIP CREATOR)          ');
console.log('=======================================================================');
console.log(`Project root: ${projectRoot}`);
console.log(`Target zip directory: ${parentDir}\n`);

// 1. DUMP DATABASE
console.log('[1/4] Dumping latest PostgreSQL database (kapmeta)...');
const pgDumpPath = 'C:\\Program Files\\PostgreSQL\\16\\bin\\pg_dump.exe';
const backupDir = path.join(projectRoot, 'db', 'backup');
if (!fs.existsSync(backupDir)) fs.mkdirSync(backupDir, { recursive: true });

const latestDumpFile = path.join(backupDir, 'kapmeta_backup_latest.sql');
const defaultDumpFile = path.join(backupDir, 'kapmeta_backup_sep14.sql');

if (fs.existsSync(pgDumpPath)) {
  try {
    const env = Object.assign({}, process.env, { PGPASSWORD: 'pos' });
    const dumpResult = spawnSync(
      pgDumpPath,
      ['-h', 'localhost', '-p', '5432', '-U', 'pos', '-d', 'kapmeta', '-F', 'p', '-b', '-f', latestDumpFile],
      { env, encoding: 'utf8' }
    );
    if (dumpResult.error) throw dumpResult.error;
    if (dumpResult.status !== 0) throw new Error(dumpResult.stderr || `Exit code ${dumpResult.status}`);
    
    // Also copy to default dump file used by Restore_Database.bat
    fs.copyFileSync(latestDumpFile, defaultDumpFile);
    const dumpStat = fs.statSync(latestDumpFile);
    console.log(`  ✓ Database dumped successfully: ${(dumpStat.size / 1024 / 1024).toFixed(2)} MB`);
  } catch (err) {
    console.warn(`  ⚠ pg_dump note: ${err.message}. Using existing SQL dump files in db/backup.`);
  }
} else {
  console.log('  ℹ pg_dump not found in PostgreSQL 16 path. Using existing dump files.');
}

// Helper to run tar to create zip
function createZip(zipFileName, fileList, excludes = []) {
  const zipPath = path.join(parentDir, zipFileName);
  if (fs.existsSync(zipPath)) {
    try { fs.unlinkSync(zipPath); } catch (_) {}
  }
  
  const args = ['-a', '-c', '-f', zipPath];
  excludes.forEach(ex => {
    args.push(`--exclude=${ex}`);
  });
  fileList.forEach(f => args.push(f));

  console.log(`\n  Creating ${zipFileName}...`);
  const res = spawnSync('tar.exe', args, { cwd: projectRoot, encoding: 'utf8' });
  if (res.error) throw res.error;
  if (res.status !== 0) {
    console.error(`  Error creating ${zipFileName}:`, res.stderr);
  } else {
    const stats = fs.statSync(zipPath);
    console.log(`  ✓ ${zipFileName} created: ${(stats.size / 1024 / 1024).toFixed(2)} MB`);
  }
  return zipPath;
}

// 2. CREATE DATABASE.ZIP
console.log('\n[2/4] Packaging database.zip...');
const dbFiles = [
  'db',
  'Restore_Database.bat',
  'scripts/setup-users-roles.sql',
  'scripts/db-migrate.js',
  'scripts/db-verify.js',
  'scripts/seed-dynamic-data.ts',
  'README.md'
].filter(f => fs.existsSync(path.join(projectRoot, f)));
createZip('database.zip', dbFiles);

// 3. CREATE FRONTEND.ZIP
console.log('\n[3/4] Packaging frontend.zip...');
const frontendFiles = [
  'apps/pos-web',
  'apps/admin-web',
  'packages',
  'package.json',
  'package-lock.json',
  'tsconfig.json',
  'Start_PetPooja.bat',
  'Stop_PetPooja.bat',
  'Status_PetPooja.bat',
  '.env.example',
  '.env',
  'README.md'
].filter(f => fs.existsSync(path.join(projectRoot, f)));

const frontendExcludes = [
  'apps/pos-web/node_modules',
  'apps/pos-web/.next',
  'apps/pos-web/tsconfig.tsbuildinfo',
  'apps/admin-web/node_modules',
  'node_modules',
  '.git'
];
createZip('frontend.zip', frontendFiles, frontendExcludes);

// 4. CREATE BACKEND.ZIP
console.log('\n[4/4] Packaging backend.zip...');
const backendFiles = [
  'apps/api',
  'services',
  'packages',
  'scripts',
  'db',
  'docs',
  'brain',
  'package.json',
  'package-lock.json',
  'tsconfig.json',
  'eslint.config.js',
  'redocly.yaml',
  'Start_PetPooja.bat',
  'Stop_PetPooja.bat',
  'Status_PetPooja.bat',
  '.env.example',
  '.env',
  'README.md'
].filter(f => fs.existsSync(path.join(projectRoot, f)));

const backendExcludes = [
  'apps/api/node_modules',
  'node_modules',
  '.git',
  'logs',
  'playwright-report',
  'test-results'
];
createZip('backend.zip', backendFiles, backendExcludes);

// 5. CREATE COMPLETE PROJECT ZIP (PetPooja_Complete.zip)
console.log('\n[BONUS] Packaging complete standalone project (PetPooja_Complete.zip)...');
const allRootItems = fs.readdirSync(projectRoot).filter(item => {
  return ![
    'node_modules',
    '.git',
    '.next',
    'logs',
    'playwright-report',
    'test-results',
    '.running_pids.json'
  ].includes(item);
});

const completeExcludes = [
  'node_modules',
  '*/node_modules',
  '*/*/node_modules',
  '.git',
  '*/.git',
  '.next',
  '*/.next',
  'logs',
  'playwright-report',
  'test-results'
];
createZip('PetPooja_Complete.zip', allRootItems, completeExcludes);

console.log('\n=======================================================================');
console.log('             ALL ZIP ARCHIVES GENERATED SUCCESSFULLY!                 ');
console.log('=======================================================================\n');

// Summary of archives
const zipFiles = ['database.zip', 'frontend.zip', 'backend.zip', 'PetPooja_Complete.zip'];
zipFiles.forEach(z => {
  const p = path.join(parentDir, z);
  if (fs.existsSync(p)) {
    const sz = (fs.statSync(p).size / 1024 / 1024).toFixed(2);
    console.log(`  • ${z.padEnd(24)}: ${sz} MB -> ${p}`);
  }
});
console.log('');
