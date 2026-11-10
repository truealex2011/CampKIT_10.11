import fs from 'node:fs';

const port = 9229;
const target = process.argv[2] ?? 'http://localhost:8731/';
const out = process.argv[3] ?? 'build/shots/web.png';
const width = Number(process.argv[4] ?? 393);
const height = Number(process.argv[5] ?? 852);
const waitMs = Number(process.argv[6] ?? 12000);
const taps = (process.argv[7] ?? '')
  .split(';')
  .filter(Boolean)
  .map((p) => p.split(',').map(Number));
const extraWaits = (process.argv[8] ?? '')
  .split(';')
  .filter(Boolean)
  .map(Number);

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

let list;
for (let i = 0; i < 40; i++) {
  try {
    list = await (await fetch(`http://127.0.0.1:${port}/json`)).json();
    if (list.some((t) => t.type === 'page')) break;
  } catch {}
  await sleep(500);
}
if (!list) throw new Error('chrome devtools not reachable');

const page = list.find((t) => t.type === 'page' && t.url.startsWith('http'))
  ?? list.find((t) => t.type === 'page');
const ws = new WebSocket(page.webSocketDebuggerUrl);
await new Promise((res, rej) => {
  ws.onopen = res;
  ws.onerror = rej;
});

let nextId = 1;
const pending = new Map();
const console_ = [];
ws.onmessage = (ev) => {
  const msg = JSON.parse(ev.data);
  if (msg.id && pending.has(msg.id)) {
    pending.get(msg.id)(msg);
    pending.delete(msg.id);
  } else if (msg.method === 'Runtime.exceptionThrown') {
    console_.push(
      'EXC ' +
        JSON.stringify(msg.params.exceptionDetails?.exception?.description ?? '')
          .slice(0, 300),
    );
  } else if (msg.method === 'Log.entryAdded' && msg.params.entry.level === 'error') {
    console_.push('LOG ' + msg.params.entry.text.slice(0, 200));
  } else if (msg.method === 'Runtime.consoleAPICalled') {
    const text = (msg.params.args ?? [])
      .map((a) => a.value ?? a.description ?? '')
      .join(' ')
      .slice(0, 200);
    if (text) console_.push('CON ' + text);
  }
};

const send = (method, params = {}) =>
  new Promise((res) => {
    const id = nextId++;
    pending.set(id, res);
    ws.send(JSON.stringify({ id, method, params }));
  });

await send('Page.enable');
await send('Runtime.enable');
await send('Log.enable');
await send('Network.enable');
await send('Network.setCacheDisabled', { cacheDisabled: true });
await send('Storage.clearDataForOrigin', {
  origin: new URL(target).origin,
  storageTypes: 'all',
});
await send('Runtime.evaluate', {
  expression: `(async () => {
    const regs = (await navigator.serviceWorker?.getRegistrations()) ?? [];
    await Promise.all(regs.map((r) => r.unregister()));
    const keys = (await window.caches?.keys()) ?? [];
    await Promise.all(keys.map((k) => caches.delete(k)));
  })()`,
  awaitPromise: true,
});
await send('Page.navigate', { url: target });
await send('Page.bringToFront');
await sleep(waitMs);
await send('Emulation.setDeviceMetricsOverride', {
  width,
  height,
  deviceScaleFactor: 2,
  mobile: true,
});
await sleep(5000);

for (let i = 0; i < taps.length; i++) {
  const [x, y] = taps[i];
  await send('Input.dispatchMouseEvent', {
    type: 'mousePressed',
    x,
    y,
    button: 'left',
    clickCount: 1,
  });
  await send('Input.dispatchMouseEvent', {
    type: 'mouseReleased',
    x,
    y,
    button: 'left',
    clickCount: 1,
  });
  await sleep(extraWaits[i] ?? 1500);
}

await send('Page.bringToFront');
await sleep(400);
const shot = await send('Page.captureScreenshot', { format: 'png' });
fs.mkdirSync('build/shots', { recursive: true });
fs.writeFileSync(out, Buffer.from(shot.result.data, 'base64'));
console.log('saved', out, fs.statSync(out).size, 'bytes');
const secondDelay = Number(process.argv[9] ?? 0);
if (secondDelay > 0) {
  await sleep(secondDelay);
  const shot2 = await send('Page.captureScreenshot', { format: 'png' });
  const out2 = out.replace(/\.png$/, '_b.png');
  fs.writeFileSync(out2, Buffer.from(shot2.result.data, 'base64'));
  console.log('saved', out2, fs.statSync(out2).size, 'bytes');
}
const probe = await send('Runtime.evaluate', {
  expression: `JSON.stringify({
    canvases: document.querySelectorAll('canvas').length,
    flutter: !!window.flutterCanvasKit || !!window.flutter,
    text: (document.body.innerText || '').slice(0, 300),
    ready: document.readyState
  })`,
  returnByValue: true,
});
console.log('DOM', probe.result?.result?.value);
if (console_.length) console.log(console_.slice(0, 15).join('\n'));
ws.close();
