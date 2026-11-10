// Pinned OFL font used by the HTML reference; no system font installation.
import {mkdir, writeFile} from 'node:fs/promises';
import {createHash} from 'node:crypto';
const files = [
  ['474033a95d364e910e5dc985a56802c474eeedb3', 'CascadiaMono.ttf'],
  ['40f856f6ecc6de260b4065368ad2f5c4f8cbdcbc', 'OFL.txt'],
];
await mkdir('assets/fonts', {recursive: true});
for (const [sha, name] of files) {
  const response = await fetch(`https://api.github.com/repos/google/fonts/git/blobs/${sha}`);
  if (!response.ok) throw new Error(`font download HTTP ${response.status}`);
  const data = await response.json();
  const bytes = Buffer.from(data.content, 'base64');
  const actual = createHash('sha1').update(`blob ${bytes.length}\0`).update(bytes).digest('hex');
  if (actual !== sha) throw new Error('font integrity mismatch');
  await writeFile(`assets/fonts/${name}`, bytes);
  console.log(`${name}: ${bytes.length} bytes; pinned git SHA verified`);
}
