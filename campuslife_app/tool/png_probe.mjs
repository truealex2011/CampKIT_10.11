import fs from 'node:fs';
import zlib from 'node:zlib';

const file = process.argv[2];
const buf = fs.readFileSync(file);

let pos = 8;
let width = 0, height = 0, bitDepth = 0, colorType = 0;
const idat = [];
while (pos < buf.length) {
  const len = buf.readUInt32BE(pos);
  const type = buf.toString('ascii', pos + 4, pos + 8);
  const data = buf.subarray(pos + 8, pos + 8 + len);
  if (type === 'IHDR') {
    width = data.readUInt32BE(0);
    height = data.readUInt32BE(4);
    bitDepth = data[8];
    colorType = data[9];
  } else if (type === 'IDAT') idat.push(Buffer.from(data));
  pos += 12 + len;
}

const raw = zlib.inflateSync(Buffer.concat(idat));
const channels = colorType === 6 ? 4 : colorType === 2 ? 3 : 4;
const stride = width * channels;
const out = Buffer.alloc(height * stride);
let rp = 0;
for (let y = 0; y < height; y++) {
  const filter = raw[rp++];
  for (let x = 0; x < stride; x++) {
    const cur = raw[rp + x];
    const a = x >= channels ? out[y * stride + x - channels] : 0;
    const b = y > 0 ? out[(y - 1) * stride + x] : 0;
    const c = x >= channels && y > 0 ? out[(y - 1) * stride + x - channels] : 0;
    let v;
    switch (filter) {
      case 0: v = cur; break;
      case 1: v = cur + a; break;
      case 2: v = cur + b; break;
      case 3: v = cur + ((a + b) >> 1); break;
      case 4: {
        const p = a + b - c;
        const pa = Math.abs(p - a), pb = Math.abs(p - b), pc = Math.abs(p - c);
        v = cur + (pa <= pb && pa <= pc ? a : pb <= pc ? b : c);
        break;
      }
      default: v = cur;
    }
    out[y * stride + x] = v & 0xff;
  }
  rp += stride;
}

const px = (x, y) => {
  const i = y * stride + x * channels;
  return [out[i], out[i + 1], out[i + 2], out[i + 3]];
};

console.log(`${file} ${width}x${height} depth=${bitDepth} color=${colorType}`);
const pts = process.argv.slice(3).map((s) => s.split(',').map(Number));
for (const [x, y] of pts) {
  console.log(`  (${x},${y}) = rgba(${px(x, y).join(',')})`);
}

const hist = new Map();
for (let y = 0; y < height; y += 7) {
  for (let x = 0; x < width; x += 7) {
    const [r, g, b] = px(x, y);
    const key = `${r >> 4},${g >> 4},${b >> 4}`;
    hist.set(key, (hist.get(key) || 0) + 1);
  }
}
const top = [...hist.entries()].sort((a, b) => b[1] - a[1]).slice(0, 12);
console.log('  top colours (r,g,b nibbles):', top.map(([k, v]) => `${k}:${v}`).join(' '));
