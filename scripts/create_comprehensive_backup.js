const { spawnSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const projectRoot = path.resolve(__dirname, '..');
const parentDir = path.resolve(projectRoot, '..');

const now = new Date();
const timestamp = now.toISOString().replace(/[:.]/g, '-').replace('T', '_').slice(0, 19);
const backupOutputDir = path.join(parentDir, 'backups', `backup_${timestamp}`);

if (!fs.existsSync(backupOutputDir)) {
  fs.mkdirSync(backupOutputDir, { recursive: true });
}

console.log('=======================================================================');
console.log('       PETPOOJA / KAPMETA FULL SYSTEM BACKUP ENGINE                    ');
console.log('=======================================================================');
console.log(`Timestamp           : ${timestamp}`);
console.log(`Source Project Root : ${projectRoot}`);
console.log(`Backup Destination  : ${backupOutputDir}\n`);

// 1. DUMP DATABASE
console.log('[1/5] Dumping PostgreSQL Database (kapmeta)...');
const pgDumpPath = 'C:\\Program Files\\PostgreSQL\\16\\bin\\pg_dump.exe';
const internalDbDir = path.join(projectRoot, 'db', 'backup');
if (!fs.existsSync(internalDbDir)) fs.mkdirSync(internalDbDir, { recursive: true });

const internalLatestDump = path.join(internalDbDir, 'kapmeta_backup_latest.sql');
const backupFolderSql = path.join(backupOutputDir, `kapmeta_database_${timestamp}.sql`);

if (fs.existsSync(pgDumpPath)) {
  try {
    const env = Object.assign({}, process.env, { PGPASSWORD: 'pos' });
    const dumpResult = spawnSync(
      pgDumpPath,
      ['-h', 'localhost', '-p', '5432', '-U', 'pos', '-d', 'kapmeta', '-F', 'p', '-b', '-f', backupFolderSql],
      { env, encoding: 'utf8' }
    );
    if (dumpResult.error) throw dumpResult.error;
    if (dumpResult.status !== 0) throw new Error(dumpResult.stderr || `Exit code ${dumpResult.status}`);

    // Copy to internal db/backup directory as well
    fs.copyFileSync(backupFolderSql, internalLatestDump);
    const dumpStat = fs.statSync(backupFolderSql);
    console.log(`  ✓ Database dumped successfully: ${(dumpStat.size / (1024 * 1024)).toFixed(2)} MB -> ${backupFolderSql}`);
  } catch (err) {
    console.error(`  ❌ pg_dump error: ${err.message}`);
  }
} else {
  console.warn('  ⚠️ pg_dump.exe not found at standard path.');
}

// Helper to create zip archive using tar.exe
function makeArchive(zipName, sourceFiles, excludes = [], targetDir = backupOutputDir) {
  const zipPath = path.join(targetDir, zipName);
  if (fs.existsSync(zipPath)) {
    try { fs.unlinkSync(zipPath); } catch (_) {}
  }

  const args = ['-a', '-c', '-f', zipPath];
  for (const ex of excludes) {
    args.push(`--exclude=${ex}`);
  }
  for (const f of sourceFiles) {
    args.push(f);
  }

  console.log(`  Archiving ${zipName}...`);
  const res = spawnSync('tar.exe', args, { cwd: projectRoot, encoding: 'utf8' });
  if (res.error) throw res.error;
  if (res.status !== 0) {
    console.error(`  ❌ Error archiving ${zipName}:`, res.stderr);
  } else {
    const stats = fs.statSync(zipPath);
    console.log(`  ✓ Created ${zipName}: ${(stats.size / (1024 * 1024)).toFixed(2)} MB`);
  }
  return zipPath;
}

// 2. PACKAGE DATABASE ZIP
console.log('\n[2/5] Packaging Database and Migrations Archive...');
const dbFiles = [
  'db',
  'kapmeta/schema.prisma',
  'Restore_Database.bat',
  'scripts/setup-users-roles.sql',
  'scripts/db-migrate.js',
  'scripts/db-verify.js',
  'scripts/seed-dynamic-data.ts',
  'scripts/seed_demo_recipes.js',
  'README.md'
].filter(f => fs.existsSync(path.join(projectRoot, f)));

makeArchive(`database_${timestamp}.zip`, dbFiles);
makeArchive('database.zip', dbFiles, [], parentDir);

// 3. PACKAGE FRONTEND ZIP
console.log('\n[3/5] Packaging Frontend (pos-web, admin-web, shared UI & dependencies)...');
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

makeArchive(`frontend_${timestamp}.zip`, frontendFiles, frontendExcludes);
makeArchive('frontend.zip', frontendFiles, frontendExcludes, parentDir);

// 4. PACKAGE BACKEND ZIP
console.log('\n[4/5] Packaging Backend (API, Services, Orchestration, Logics & Workflows)...');
const backendFiles = [
  'apps/api',
  'services',
  'packages',
  'scripts',
  'db',
  'docs',
  'brain',
  'kapmeta',
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

makeArchive(`backend_${timestamp}.zip`, backendFiles, backendExcludes);
makeArchive('backend.zip', backendFiles, backendExcludes, parentDir);

// 5. PACKAGE COMPLETE STANDALONE PROJECT
console.log('\n[5/5] Packaging Complete Standalone Project (PetPooja_Complete)...');
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

makeArchive(`PetPooja_Complete_${timestamp}.zip`, allRootItems, completeExcludes);
makeArchive('PetPooja_Complete.zip', allRootItems, completeExcludes, parentDir);

// 6. EXTRACT DEPENDENCIES MANIFEST
console.log('\n[Extra] Extracting Dependencies Manifest...');
const rootPkg = JSON.parse(fs.readFileSync(path.join(projectRoot, 'package.json'), 'utf8'));
const apiPkg = fs.existsSync(path.join(projectRoot, 'apps/api/package.json'))
  ? JSON.parse(fs.readFileSync(path.join(projectRoot, 'apps/api/package.json'), 'utf8'))
  : {};
const posPkg = fs.existsSync(path.join(projectRoot, 'apps/pos-web/package.json'))
  ? JSON.parse(fs.readFileSync(path.join(projectRoot, 'apps/pos-web/package.json'), 'utf8'))
  : {};

const dependencyManifest = {
  timestamp,
  nodeVersion: process.version,
  rootDependencies: rootPkg.dependencies || {},
  rootDevDependencies: rootPkg.devDependencies || {},
  apiDependencies: apiPkg.dependencies || {},
  posWebDependencies: posPkg.dependencies || {},
  workspaces: rootPkg.workspaces || []
};

fs.writeFileSync(
  path.join(backupOutputDir, `dependencies_manifest_${timestamp}.json`),
  JSON.stringify(dependencyManifest, null, 2),
  'utf8'
);
console.log('  ✓ Created dependencies manifest');

// 7. WRITE README / RESTORE GUIDE
const readmeContent = `# PetPooja / Kapmeta Full System Backup (${timestamp})

## Contents of this Backup
- **Database Dump**: \`kapmeta_database_${timestamp}.sql\` (Complete PostgreSQL schema + data + sequences)
- **Database Archive**: \`database_${timestamp}.zip\` (Migrations, schemas, seeders, restore scripts)
- **Frontend Archive**: \`frontend_${timestamp}.zip\` (Next.js pos-web, admin-web, shared UI, components)
- **Backend Archive**: \`backend_${timestamp}.zip\` (Express API gateway, services, business logic, orchestration)
- **Complete Project**: \`PetPooja_Complete_${timestamp}.zip\` (Full monolithic codebase with all workflows and configurations)
- **Dependencies Manifest**: \`dependencies_manifest_${timestamp}.json\`

## How to Restore

### 1. Restore Database
Run the following in PowerShell/CMD:
\`\`\`powershell
$env:PGPASSWORD="pos"
& "C:\\Program Files\\PostgreSQL\\16\\bin\\psql.exe" -h localhost -p 5432 -U pos -d kapmeta -f "kapmeta_database_${timestamp}.sql"
\`\`\`
Or run: \`Restore_Database.bat\`

### 2. Restore Dependencies
Inside the project root:
\`\`\`bash
npm install
npm run db:migrate
\`\`\`

### 3. Start the System
\`\`\`bash
npm run start:all
# or double-click Start_PetPooja.bat
\`\`\`
`;

fs.writeFileSync(path.join(backupOutputDir, 'RESTORE_GUIDE.md'), readmeContent, 'utf8');

console.log('\n=======================================================================');
console.log('         FULL SYSTEM BACKUP GENERATED SUCCESSFULLY!                   ');
console.log('=======================================================================');
console.log(`Directory: ${backupOutputDir}`);
fs.readdirSync(backupOutputDir).forEach(file => {
  const fullPath = path.join(backupOutputDir, file);
  const size = (fs.statSync(fullPath).size / (1024 * 1024)).toFixed(2);
  console.log(`  • ${file.padEnd(40)}: ${size.padStart(6)} MB`);
});
console.log('\nRoot zip files updated in parent directory as well:');
['database.zip', 'frontend.zip', 'backend.zip', 'PetPooja_Complete.zip'].forEach(z => {
  const p = path.join(parentDir, z);
  if (fs.existsSync(p)) {
    const sz = (fs.statSync(p).size / (1024 * 1024)).toFixed(2);
    console.log(`  • ${z.padEnd(25)}: ${sz.padStart(6)} MB`);
  }
});
