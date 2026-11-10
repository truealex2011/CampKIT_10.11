import fs from 'node:fs';

const port = 9229;
const target = 'http://localhost:8731/';
const stage = process.argv[2] ?? 'a';

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
let frameSeq = 0;
ws.onmessage = (ev) => {
  const msg = JSON.parse(ev.data);
  if (msg.id && pending.has(msg.id)) {
    pending.get(msg.id)(msg);
    pending.delete(msg.id);
  } else if (msg.method === 'Page.screencastFrame') {
    latestFrame = msg.params.data;
    frameSeq++;
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
if (stage !== 'e') {
  await send('Emulation.setDeviceMetricsOverride', { width: 393, height: 852, deviceScaleFactor: 2, mobile: true });
}

const tap = async (x, y) => {
  await send('Input.dispatchMouseEvent', { type: 'mousePressed', x, y, button: 'left', clickCount: 1 });
  await send('Input.dispatchMouseEvent', { type: 'mouseReleased', x, y, button: 'left', clickCount: 1 });
};
const drag = async (x0, y0, x1, y1, steps = 10) => {
  await send('Input.dispatchMouseEvent', { type: 'mousePressed', x: x0, y: y0, button: 'left', clickCount: 1, buttons: 1 });
  for (let i = 1; i <= steps; i++) {
    await send('Input.dispatchMouseEvent', {
      type: 'mouseMoved',
      x: x0 + (x1 - x0) * i / steps,
      y: y0 + (y1 - y0) * i / steps,
      button: 'left',
      buttons: 1,
    });
    await sleep(30);
  }
  await send('Input.dispatchMouseEvent', { type: 'mouseReleased', x: x1, y: y1, button: 'left', buttons: 0 });
};
const touchDrag = async (x0, y0, x1, y1, steps = 12) => {
  await send('Input.dispatchTouchEvent', { type: 'touchStart', touchPoints: [{ x: x0, y: y0 }] });
  for (let i = 1; i <= steps; i++) {
    await send('Input.dispatchTouchEvent', {
      type: 'touchMove',
      touchPoints: [{ x: x0 + (x1 - x0) * i / steps, y: y0 + (y1 - y0) * i / steps }],
    });
    await sleep(24);
  }
  await send('Input.dispatchTouchEvent', { type: 'touchEnd', touchPoints: [] });
};
const type = async (text) => {
  await send('Input.insertText', { text });
};
const shot = async (name) => {
  const seq = frameSeq;
  for (let i = 0; i < 20 && frameSeq === seq; i++) await sleep(150);
  await sleep(250);
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
  await send('Emulation.setDeviceMetricsOverride', { width: 393, height: 852, deviceScaleFactor: 2, mobile: true });
  await sleep(2000);
  for (let i = 0; i < 60; i++) {
    await sleep(1000);
    const r = await send('Runtime.evaluate', {
      expression: `!!document.querySelector('flt-glass-pane')?.shadowRoot?.querySelector('canvas')`,
      returnByValue: true,
    });
    if (r.result?.result?.value === true) break;
  }
  await sleep(6000);
};
const login = async (chipX) => {
  await tap(196, 700);
  await sleep(1000);
  await tap(chipX, 522);
  await sleep(3000);
  await tap(chipX, 522);
  await sleep(4000);
};

const stages = {
  a: async () => {
    await nav();
    await login(73);
    await shot('q01_feed_rest');
    await drag(352, 515, 292, 515, 12);
    await sleep(1200);
    await shot('q02_drag_register');
    await tap(357, 610);
    await sleep(1500);
    await shot('q03_sheet');
    await tap(196, 200);
    await sleep(1200);
    await shot('q04_barrier_tap');
  },
  b: async () => {
    await nav();
    await login(177);
    await tap(196, 815);
    await sleep(1800);
    await tap(196, 131);
    await sleep(400);
    await type('Тестовый квиз');
    await sleep(400);
    await tap(196, 309);
    await sleep(1000);
    await shot('q08_cat_menu');
    await tap(196, 360);
    await sleep(700);
    await shot('q09_step1');
    await tap(285, 815);
    await sleep(1200);
    await shot('q10_step2');
  },
  c: async () => {
    await shot('c01_sheet_now');
    await send('Input.dispatchMouseEvent', { type: 'mousePressed', x: 196, y: 200, button: 'left', clickCount: 1 });
    await sleep(120);
    await send('Input.dispatchMouseEvent', { type: 'mouseReleased', x: 196, y: 200, button: 'left', clickCount: 1 });
    await sleep(1200);
    await shot('c02_barrier_slow');
    await send('Input.dispatchKeyEvent', { type: 'keyDown', key: 'Escape', code: 'Escape', windowsVirtualKeyCode: 27 });
    await send('Input.dispatchKeyEvent', { type: 'keyUp', key: 'Escape', code: 'Escape', windowsVirtualKeyCode: 27 });
    await sleep(1200);
    await shot('c03_escape');
    await drag(196, 437, 196, 830, 14);
    await sleep(1400);
    await shot('c04_handle_drag');
  },
  g: async () => {
    await shot('g01_feed');
    await tap(34, 677);
    await sleep(1500);
    await shot('g02_reminder_sheet');
    await tap(196, 200);
    await sleep(1200);
    await shot('g03_reminder_barrier');
    await drag(196, 600, 196, 220, 12);
    await sleep(1600);
    await shot('g04_swipe_up');
  },
  h: async () => {
    await nav();
    await login(73);
    await shot('h01_feed');
    await drag(352, 515, 292, 515, 12);
    await sleep(500);
    await shot('h02_toast');
    await tap(357, 610);
    await sleep(1500);
    await shot('h03_sheet');
    await tap(196, 200);
    await sleep(1000);
    await shot('h04_barrier');
    await tap(196, 80);
    await sleep(1000);
    await shot('h05_barrier_top');
    await drag(196, 437, 196, 840, 14);
    await sleep(1400);
    await shot('h06_handle_drag');
    await drag(196, 600, 196, 220, 12);
    await sleep(1600);
    await shot('h07_swipe_up');
  },
  c: async () => {
    await tap(196, 281);
    await sleep(400);
    await type('Актовый зал, корпус 2');
    await sleep(300);
    await tap(196, 347);
    await sleep(400);
    await type('30');
    await sleep(300);
    await shot('c01_step2_filled');
    await tap(285, 815);
    await sleep(1400);
    await shot('c02_step3');
  },
  w: async () => {
    await nav();
    await login(73);
    await send('Emulation.setDeviceMetricsOverride', { width: 1280, height: 800, deviceScaleFactor: 1, mobile: false });
    await sleep(2000);
    await send('Input.synthesizeScrollGesture', { x: 640, y: 400, xDistance: 0, yDistance: -600, speed: 800, gestureSourceType: 'wheel' });
    await sleep(1800);
    await shot('w01_synth_wheel');
  },
  p: async () => {
    await tap(285, 815);
    await sleep(1200);
    await shot('p01_step4');
    await tap(285, 815);
    await sleep(1200);
    await shot('p02_step5');
    await tap(285, 815);
    await sleep(1200);
    await shot('p03_step6');
    await tap(196, 330);
    await sleep(2500);
    await shot('p04_submitted');
  },
  q: async () => {
    await tap(285, 815);
    await sleep(1200);
    await shot('q10_pub_step');
    await tap(196, 330);
    await sleep(2500);
    await shot('q11_submitted');
  },
  o: async () => {
    await touchDrag(196, 700, 196, 300);
    await sleep(1200);
    await shot('o01_org_list_scrolled');
    await touchDrag(196, 700, 196, 300);
    await sleep(1200);
    await shot('o02_org_list_scrolled2');
  },
  s: async () => {
    await nav();
    await login(271);
    await tap(60, 265);
    await sleep(2000);
    await shot('s01_moderation');
  },
  v: async () => {
    await nav();
    await login(73);
    await send('Emulation.setDeviceMetricsOverride', { width: 1280, height: 800, deviceScaleFactor: 1, mobile: false });
    await sleep(1500);
    await send('Runtime.evaluate', {
      expression: `window.__wheel = 0; window.addEventListener('wheel', () => window.__wheel++, { passive: true, capture: true }); true`,
      returnByValue: true,
    });
    await send('Input.synthesizeScrollGesture', { x: 640, y: 400, xDistance: 0, yDistance: -600, speed: 800, gestureSourceType: 'wheel' });
    await sleep(1500);
    const r = await send('Runtime.evaluate', { expression: `window.__wheel`, returnByValue: true });
    console.log('wheel events at window:', r.result?.result?.value);
    await shot('v01_after_wheel');
  },
  i: async () => {
    await shot('i01_sheet');
    await tap(196, 815);
    await sleep(1200);
    await shot('i02_sheet_button');
    await tap(196, 200);
    await sleep(1200);
    await shot('i03_barrier');
  },
  j: async () => {
    await nav();
    await login(73);
    await shot('j01_feed');
    await send('Input.dispatchMouseEvent', { type: 'mouseWheel', x: 196, y: 400, deltaX: 0, deltaY: -500 });
    await sleep(1600);
    await shot('j02_wheel');
    await drag(196, 700, 196, 160, 8);
    await sleep(1600);
    await shot('j03_fast_drag');
  },
  k: async () => {
    await nav();
    await login(73);
    await shot('k01_feed');
    await touchDrag(196, 650, 196, 220);
    await sleep(1600);
    await shot('k02_touch_swipe');
    await send('Input.dispatchMouseEvent', { type: 'mouseWheel', x: 196, y: 400, deltaX: 0, deltaY: -500 });
    await sleep(1600);
    await shot('k03_wheel');
    await tap(357, 610);
    await sleep(1500);
    await shot('k04_sheet');
    await touchDrag(196, 338, 196, 720);
    await sleep(1400);
    await shot('k05_handle_close');
  },
  m: async () => {
    await nav();
    await login(73);
    await shot('m01_feed');
    await send('Input.dispatchMouseEvent', { type: 'mouseWheel', x: 196, y: 400, deltaX: 0, deltaY: -600 });
    await sleep(1600);
    await shot('m02_wheel');
    await tap(357, 610);
    await sleep(1500);
    await shot('m03_sheet');
    await tap(356, 369);
    await sleep(1200);
    await shot('m04_x_close');
    await tap(357, 610);
    await sleep(1500);
    await touchDrag(196, 338, 196, 780);
    await sleep(2500);
    await shot('m05_drag_close');
    await sleep(1200);
    await shot('m06_late');
  },
  n: async () => {
    await nav();
    await login(73);
    await send('Emulation.setDeviceMetricsOverride', { width: 1280, height: 800, deviceScaleFactor: 1, mobile: false });
    await sleep(2000);
    await shot('n01_desktop_feed');
    await send('Input.dispatchMouseEvent', { type: 'mouseWheel', x: 640, y: 400, deltaX: 0, deltaY: -600 });
    await sleep(1600);
    await shot('n02_desktop_wheel');
  },
  d: async () => {
    await nav();
    await login(177);
    await tap(227, 680);
    await sleep(2500);
    await shot('q20_checkin');
  },
  d2: async () => {
    await tap(196, 215);
    await sleep(400);
    await type('u_participant');
    await sleep(300);
    await tap(196, 267);
    await sleep(1300);
    await shot('d01_checkin_negative');
    await tap(196, 215);
    await sleep(400);
    await send('Input.dispatchKeyEvent', { type: 'keyDown', key: 'a', code: 'KeyA', windowsVirtualKeyCode: 65, modifiers: 2 });
    await send('Input.dispatchKeyEvent', { type: 'keyUp', key: 'a', code: 'KeyA', windowsVirtualKeyCode: 65, modifiers: 2 });
    await type('ev_3:u_participant');
    await sleep(300);
    await tap(196, 267);
    await sleep(1300);
    await shot('d02_checkin_cross');
    await nav();
    await login(271);
    await tap(150, 265);
    await sleep(2000);
    await shot('d03_keys');
    await tap(196, 345);
    await sleep(1800);
    await shot('d04_key_minted');
  },
  d3: async () => {
    await nav();
    await login(177);
    await tap(227, 680);
    await sleep(2500);
    await tap(196, 215);
    await sleep(400);
    await type('u_participant');
    await sleep(300);
    await tap(196, 267);
    await sleep(1300);
    await shot('d01_checkin_negative');
    await tap(196, 215);
    await sleep(400);
    await send('Input.dispatchKeyEvent', { type: 'keyDown', key: 'a', code: 'KeyA', windowsVirtualKeyCode: 65, modifiers: 2 });
    await send('Input.dispatchKeyEvent', { type: 'keyUp', key: 'a', code: 'KeyA', windowsVirtualKeyCode: 65, modifiers: 2 });
    await type('ev_3:u_participant');
    await sleep(300);
    await tap(196, 267);
    await sleep(1300);
    await shot('d02_checkin_cross');
  },
  d4: async () => {
    await nav();
    await login(177);
    await tap(227, 680);
    await sleep(2500);
    await tap(196, 215);
    await sleep(400);
    await type('ev_3:u_participant');
    await sleep(300);
    await tap(196, 267);
    await sleep(1300);
    await shot('d05_checkin_positive');
    await tap(196, 263);
    await sleep(400);
    await type('ev_3:u_participant');
    await sleep(400);
    await tap(196, 267);
    await sleep(1300);
    await shot('d06_checkin_duplicate');
  },
  s2: async () => {
    await nav();
    await login(271);
    await tap(60, 265);
    await sleep(2000);
    await shot('s02_mod_top');
    await touchDrag(196, 720, 196, 280);
    await sleep(1300);
    await shot('s03_mod_scroll');
  },
  s3: async () => {
    await nav();
    await login(271);
    await tap(60, 265);
    await sleep(2000);
    await touchDrag(196, 720, 196, 280);
    await sleep(1300);
    await tap(285, 428);
    await sleep(1600);
    await shot('s04_approved');
    await sleep(1500);
    await shot('s05_after_approve');
  },
  s4: async () => {
    await touchDrag(196, 700, 196, 500);
    await sleep(1200);
    await shot('s06_reject_buttons');
    await tap(105, 668);
    await sleep(1400);
    await shot('s07_reject_sheet');
  },
  s5: async () => {
    await tap(105, 745);
    await sleep(1400);
    await shot('s07_reject_sheet');
  },
  s6: async () => {
    await tap(196, 759);
    await sleep(300);
    await type('Нужно добавить призы и программу');
    await sleep(300);
    await shot('s07b_reason_typed');
    await tap(285, 810);
    await sleep(1800);
    await shot('s08_rejected');
  },
  r: async () => {
    await nav();
    await tap(73, 655);
    await sleep(4000);
    await shot('r01_feed_phone');
    await send('Input.dispatchMouseEvent', { type: 'mousePressed', x: 348, y: 445, button: 'left', clickCount: 1 });
    await sleep(1200);
    for (let i = 1; i <= 10; i++) {
      await send('Input.dispatchMouseEvent', { type: 'mouseMoved', x: 348 - 148 * i / 10, y: 445, button: 'left', buttons: 1 });
      await sleep(40);
    }
    await shot('r02_armed_drag');
    await send('Input.dispatchMouseEvent', { type: 'mouseReleased', x: 200, y: 445, button: 'left', buttons: 0 });
    await sleep(1800);
    await shot('r03_registered');
    await send('Emulation.setDeviceMetricsOverride', { width: 1280, height: 800, deviceScaleFactor: 1, mobile: false });
    await sleep(2500);
    await shot('r04_feed_desktop');
  },
  f: async () => {
    await nav();
    await tap(73, 655);
    await sleep(4000);
    await shot('f01_feed_fishheart');
    await tap(348, 445);
    await sleep(800);
    await shot('f02_like_off');
    await tap(348, 445);
    await shot('f03_like_fly');
    await sleep(1000);
    await shot('f04_like_filled');
    await send('Input.dispatchMouseEvent', { type: 'mousePressed', x: 348, y: 445, button: 'left', clickCount: 1 });
    await sleep(1900);
    await shot('f05_armed');
    for (let i = 1; i <= 10; i++) {
      await send('Input.dispatchMouseEvent', { type: 'mouseMoved', x: 348 - 148 * i / 10, y: 445, button: 'left', buttons: 1 });
      await sleep(40);
    }
    await shot('f06_reached');
    await send('Input.dispatchMouseEvent', { type: 'mouseReleased', x: 200, y: 445, button: 'left', buttons: 0 });
    await shot('f07_splash');
    await sleep(1500);
    await shot('f08_registered');
    await tap(359, 29);
    await sleep(1500);
    await tap(196, 96);
    await sleep(400);
    await type('ыыыы несуществующее');
    await sleep(1200);
    await shot('f09_search_empty');
    await send('Emulation.setDeviceMetricsOverride', { width: 1280, height: 800, deviceScaleFactor: 1, mobile: false });
    await sleep(2000);
    await shot('f10_search_desktop');
  },
  oc: async () => {
    await nav();
    await sleep(9000);
    await shot('oc01_entry_phone');
    await send('Emulation.setDeviceMetricsOverride', { width: 1280, height: 800, deviceScaleFactor: 1, mobile: false });
    await sleep(5000);
    await shot('oc02_entry_desktop');
  },
  u: async () => {
    await nav();
    await login(271);
    await tap(150, 265);
    await sleep(1800);
    await tap(196, 345);
    await sleep(1500);
    await shot('u01_issued');
    await touchDrag(196, 700, 196, 300);
    await sleep(1300);
    await shot('u02_key_rows');
  },
  e: async () => {
    await nav();
    await send('Emulation.setDeviceMetricsOverride', { width: 1280, height: 800, deviceScaleFactor: 1, mobile: false });
    await sleep(6000);
    await shot('q30_desktop_entry');
    await tap(196, 700);
    await sleep(800);
  },
};

await send('Page.startScreencast', { format: 'png', maxWidth: 1280, maxHeight: 852, everyNthFrame: 1 });
await stages[stage]();
await send('Page.stopScreencast');
ws.close();