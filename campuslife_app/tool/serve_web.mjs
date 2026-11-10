import {createServer} from 'node:http';
import {readFile} from 'node:fs/promises';
import {extname, join, normalize, sep} from 'node:path';

const root = join(process.cwd(), 'build', 'web');
const port = Number(process.argv[2] ?? 8731);

const types = {
  '.html': 'text/html',
  '.js': 'text/javascript',
  '.wasm': 'application/wasm',
  '.json': 'application/json',
  '.css': 'text/css',
  '.png': 'image/png',
  '.svg': 'image/svg+xml',
  '.otf': 'font/otf',
  '.map': 'application/json',
};

const server = createServer(async (req, res) => {
  const url = new URL(req.url, `http://localhost:${port}`);
  const name = url.pathname === '/' ? 'index.html' : normalize(url.pathname).slice(1);
  const file = join(root, name.replace(/\//g, sep));
  if (!file.startsWith(root)) {
    res.writeHead(403).end('forbidden');
    return;
  }
  try {
    const body = await readFile(file);
    res.writeHead(200, {
      'content-type': types[extname(file)] ?? 'application/octet-stream',
      'cross-origin-opener-policy': 'same-origin',
      'cross-origin-embedder-policy': 'require-corp',
      'cross-origin-resource-policy': 'same-origin',
      'cache-control': 'no-store',
    });
    res.end(body);
  } catch {
    res.writeHead(404, {'content-type': 'text/plain'}).end('not found');
  }
});
server.listen(port, '127.0.0.1', () => {
  console.log(`serving ${root} on http://127.0.0.1:${server.address().port}`);
});
