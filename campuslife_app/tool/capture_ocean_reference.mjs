// Capture numeric silhouette/texture data from the unchanged HTML source.
// Run from campuslife_app; needs the reference's existing esbuild dependency.
import {createRequire} from 'node:module';
import {writeFile, readFile, mkdir} from 'node:fs/promises';
import vm from 'node:vm';
const require = createRequire(new URL('../../ascii-sharks-site/package.json', import.meta.url));
const {build} = require('esbuild');
const bundle = await build({
  entryPoints: ['../ascii-sharks-site/src/renderer.ts'],
  bundle: true, format: 'cjs', platform: 'node', write: false,
});
const context = {
  module: {exports: {}},
  document: {createElement: () => ({getContext: () => new Proxy({}, {
    get: () => () => {}, set: () => true,
  })})},
};
vm.runInNewContext(bundle.outputFiles[0].text, context);
const Renderer = context.module.exports.AsciiRenderer;
const cases = [];
for (const [width, height] of [[393, 852], [1440, 900], [2560, 1440]]) {
  for (const kind of ['classic','hammerhead','zebra','tiger','greathammer','mako','thresher','nurse']) {
    const renderer = new Renderer({getContext: () => ({})});
    renderer.resize(width, height, 1);
    const length = Math.max(210, Math.min(400, Math.min(width, height) * .44));
    const nodes = new Float32Array(40);
    for (let k = 0; k < 20; k++) {
      nodes[k * 2] = width * .5 + length * .42 - length * k / 19;
      nodes[k * 2 + 1] = height * .5 + Math.sin(k / 19 * 2.1) * length * .075;
    }
    const shark = {id: 3, kind, length, nodes, speed: 57, phase: 1.3, turn: -.35, depth: .88};
    renderer.rasterizeSharks([shark], 2.75);
    const cells = [];
    for (let i = 0; i < renderer.sharkFlag.length; i++) {
      if (renderer.sharkFlag[i]) cells.push([i, renderer.sharkFlag[i], renderer.sharkShade[i], renderer.sharkKey[i]]);
    }
    cases.push({width, height, kind, length, nodes: [...nodes], cells});
  }
}
if (process.argv.includes('--check')) {
  const saved = await readFile('test/fixtures/ocean_reference.json', 'utf8');
  if (saved !== JSON.stringify(cases)) throw new Error('HTML reference fixtures differ from current source');
  console.log(`Verified ${cases.length} fixtures against original TypeScript renderer`);
} else {
  await mkdir('test/fixtures', {recursive: true});
  await writeFile('test/fixtures/ocean_reference.json', JSON.stringify(cases));
  console.log(`Captured ${cases.length} reference silhouettes from original TypeScript renderer`);
}
