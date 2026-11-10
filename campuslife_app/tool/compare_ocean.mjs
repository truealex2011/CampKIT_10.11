// Verification-only gallery. Does not change the Flutter application or HTML source.
import { createRequire } from 'node:module';
import { mkdir, writeFile, copyFile } from 'node:fs/promises';
const require = createRequire(new URL('../../ascii-sharks-site/package.json', import.meta.url));
const { build } = require('esbuild');
await mkdir('build/web/ocean-compare', {recursive: true});
await build({
  entryPoints: ['../ascii-sharks-site/src/renderer.ts'],
  bundle: true, format: 'esm', platform: 'browser',
  outfile: 'build/web/ocean-compare/reference.js',
});
await copyFile('build/ocean_shots/species.png', 'build/web/ocean-compare/flutter.png');
await writeFile('build/web/ocean-compare/index.html', `<!doctype html>
<html lang="ru"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Сравнение рыб</title>
<style>
@font-face{font-family:OceanMono;src:url('../assets/assets/fonts/CascadiaMono.ttf');font-weight:600}
*{box-sizing:border-box}body{margin:24px;background:#f6f6f3;color:#0d1117;font:16px Arial,sans-serif}
h1{font-size:24px}button{padding:12px;margin:0 8px 16px 0;cursor:pointer}
figure{margin:0;max-width:800px}img,canvas{display:block;width:100%;height:auto}
figcaption{margin:8px 0;font-weight:bold}[hidden]{display:none!important}
</style>
<h1>Восемь видов: Flutter и HTML</h1>
<p id="status">Загрузка локального шрифта…</p>
<button id="flutter">Показать Flutter</button><button id="html">Показать HTML-образец</button>
<figure id="flutter-view"><figcaption>Flutter — отрисовка Dart</figcaption><img src="flutter.png" alt="Восемь видов рыб, отрисованных Flutter"></figure>
<figure id="html-view" hidden><figcaption>HTML — исходная отрисовка</figcaption><canvas width="800" height="1120"></canvas></figure>
<script type="module">
import {AsciiRenderer} from './reference.js';
await document.fonts.load('600 6px OceanMono');
const canvas=document.querySelector('canvas');
const renderer=new AsciiRenderer(canvas);renderer.setFontFamily('OceanMono');renderer.resize(800,1120,1);
const sharks=['classic','hammerhead','zebra','tiger','greathammer','mako','thresher','nurse'].map((kind,i)=>{
 const length=310,x=375+(i%2)*400,y=120+Math.floor(i/2)*280,nodes=new Float32Array(40);
 for(let k=0;k<20;k++){nodes[k*2]=x-length*k/19;nodes[k*2+1]=y;}
 return {id:3,kind,length,nodes,speed:57,phase:1.3,turn:-.35,depth:.88};
});
renderer.render({time:2.75,sharks,fish:[],events:[],pointer:{active:false}},1/60);
const show=(html)=>{document.querySelector('#html-view').hidden=!html;document.querySelector('#flutter-view').hidden=html;};
document.querySelector('#flutter').onclick=()=>show(false);
document.querySelector('#html').onclick=()=>show(true);
await document.querySelector('img').decode();
document.querySelector('#status').textContent='Готово: одинаковые положения, масштаб, время и локальный шрифт. Без внешних ресурсов.';
</script></html>`);
console.log('Comparison ready at /ocean-compare/index.html');
