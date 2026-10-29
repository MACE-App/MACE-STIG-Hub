#!/usr/bin/env node
// Adds a macOS Edit menu to STIG Viewer 3 so Cmd+C/V/X/A/Z work.
//
// DISA's menu_controller.js only defines File/View/Help. On macOS, Electron
// routes clipboard shortcuts through Edit menu roles, so without one the
// shortcuts do nothing (right-click still works via electron-context-menu).
// hideMenu() also sets the menu to null, which would drop the shortcuts while
// an error is shown, so on macOS we keep a minimal App + Edit menu instead.
//
// Usage: node scripts/patch-sv3-menu.js <app-extracted>
// Run after `npx @electron/asar extract app.asar app-extracted`.

const fs = require('fs');
const path = require('path');

const root = process.argv[2];
if (!root) {
  console.error('Usage: node scripts/patch-sv3-menu.js <app-extracted>');
  process.exit(1);
}

const file = path.join(root, 'src', 'electron', 'menu_controller.js');
let src = fs.readFileSync(file, 'utf8');

if (src.includes("role: 'editMenu'")) {
  console.log('Already patched:', file);
  process.exit(0);
}

const patches = [
  {
    from: "let menu_template = [...(process.platform === 'darwin' ? [{ role: 'appMenu' }] : []), ...menu_list[template]];",
    to: "let menu_template = [...menu_list[template]];\n" +
      "    if (process.platform === 'darwin') {\n" +
      "      menu_template.unshift({ role: 'appMenu' });\n" +
      "      menu_template.splice(2, 0, { role: 'editMenu' });\n" +
      "    }",
  },
  {
    from: '      Menu.setApplicationMenu(null);',
    to: "      Menu.setApplicationMenu(\n" +
      "        process.platform === 'darwin' ? Menu.buildFromTemplate([{ role: 'appMenu' }, { role: 'editMenu' }]) : null\n" +
      "      );",
  },
];

for (const { from, to } of patches) {
  const count = src.split(from).length - 1;
  if (count !== 1) {
    console.error(`Expected 1 match, found ${count}. DISA may have changed menu_controller.js:\n  ${from}`);
    process.exit(1);
  }
  src = src.replace(from, to);
}

fs.writeFileSync(file, src);
console.log('Patched:', file);
