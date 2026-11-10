import fs from 'node:fs';

const port = 9229;
const target = 'http://localhost:8731/';
const segment = process.argv[2] ?? 'participant';

const list = await (await fetch(`http://127.0.0.1:${port}/json`)).json();
const page = list.find((t) => t.type === 'page' && t.url.startsWith('http'))
  ?? list.find((t) => t.type === 'page');
const ws = new WebSocket(page.webSocketDebuggerUrl);
await new Promise((res, rej) => {
  ws.onopen = res;
  ws.onerror = rej;
});

let nextId = 1;
const pending = new Map();
let latestFrame = null;
ws.onmessage = (ev) => {
  const msg = JSON.parse(ev.data);
  if (msg.id && pending.has(msg.id)) {
    pending.get(msg.id)(msg);
    pending.delete(msg.id);
  } else if (msg.method === 'Page.screencastFrame') {
    latestFrame = msg.params.data;
    ws.send(JSON.stringify({
      id: nextId++,
      method: 'Page.screencastFrameAck',
      params: { sessionId: msg.params.sessionId },
    }));
  } else if (msg.method === 'Runtime.exceptionThrown') {
    console.log('EXC', JSON.stringify(msg.params.exceptionDetails?.exception?.description ?? '').slice(0, 400));
  } else if (msg.method === 'Runtime.consoleAPICalled' && msg.params.type === 'error') {
    const text = (msg.params.args ?? []).map((a) => a.value ?? a.description ?? '').join(' ');
    console.log('ERR', text.slice(0, 300));
  }
};

const send = (method, params = {}) => new Promise((res) => {
  const id = nextId++;
  pending.set(id, res);
  ws.send(JSON.stringify({ id, method, params }));
});
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

await send('Page.enable');
await send('Runtime.enable');
await send('Network.enable');
await send('Network.setCacheDisabled', { cacheDisabled: true });
await send('Page.bringToFront');

const tap = async (x, y) => {
  await send('Input.dispatchMouseEvent', { type: 'mousePressed', x, y, button: 'left', clickCount: 1 });
  await send('Input.dispatchMouseEvent', { type: 'mouseReleased', x, y, button: 'left', clickCount: 1 });
};
const shot = async (name) => {
  await sleep(400);
  if (!latestFrame) throw new Error('no screencast frame yet');
  fs.mkdirSync('build/shots', { recursive: true });
  fs.writeFileSync(`build/shots/${name}.png`, Buffer.from(latestFrame, 'base64'));
  console.log('shot', name, fs.statSync(`build/shots/${name}.png`).size);
};
const nav = async () => {
  await send('Storage.clearDataForOrigin', { origin: new URL(target).origin, storageTypes: 'all' });
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
  await sleep(10000);
  await send('Emulation.setDeviceMetricsOverride', { width: 393, height: 852, deviceScaleFactor: 2, mobile: true });
  await sleep(11000);
};
const login = async (chipX) => {
  await tap(196, 700);
  await sleep(1000);
  await tap(chipX, 522);
  await sleep(3000);
  await tap(chipX, 522);
  await sleep(4000);
};

const tours = {
  participant: async () => {
    await nav();
    await shot('t01_entry');
    await sleep(6000);
    await shot('t01_entry_b');
    await login(73);
    await shot('t10_feed');
    await tap(359, 29);
    await sleep(2500);
    await shot('t12_search');
    await tap(34, 29);
    await sleep(2000);
    await tap(34, 29);
    await sleep(2500);
    await shot('t13_profile');
    await tap(34, 29);
    await sleep(2000);
    await tap(357, 603);
    await sleep(2500);
    await shot('t11_sheet');
  },
  register: async () => {
    await nav();
    await tap(262, 227);
    await sleep(3500);
    await shot('t02_register');
    await tap(285, 300);
    await sleep(3000);
    await shot('t03_register_org');
    await tap(90, 227);
    await sleep(3000);
    await shot('t04_back_login');
  },
  organizer: async () => {
    await nav();
    await login(177);
    await shot('t20_org');
    await tap(196, 125);
    await sleep(2500);
    await shot('t21_org_requests');
    await tap(313, 125);
    await sleep(6000);
    await shot('t22_org_stats');
    await tap(196, 815);
    await sleep(2500);
    await shot('t23_wizard');
  },
  checkin: async () => {
    await nav();
    await login(177);
    await tap(227, 680);
    await sleep(3000);
    await shot('t25_checkin');
  },
  admin: async () => {
    await nav();
    await login(271);
    await shot('t30_admin');
    await tap(150, 265);
    await sleep(2500);
    await shot('t31_admin_keys');
    await tap(230, 265);
    await sleep(2500);
    await shot('t32_admin_manage');
    await tap(325, 265);
    await sleep(2500);
    await shot('t33_admin_reports');
  },
};

await send('Page.startScreencast', { format: 'png', maxWidth: 393, maxHeight: 852, everyNthFrame: 1 });
await tours[segment]();
await send('Page.stopScreencast');
ws.close();
