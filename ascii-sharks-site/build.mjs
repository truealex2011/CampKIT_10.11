import { build } from "esbuild";
import { readFile, writeFile } from "node:fs/promises";

const result = await build({
  entryPoints: ["main.ts"],
  bundle: true,
  format: "iife",
  target: "es2020",
  minify: true,
  write: false,
});

const template = await readFile("page.html", "utf8");
const page = template.replace("/*__BUNDLE__*/", () => result.outputFiles[0].text);
await writeFile("../CampusLife.html", page);

console.log(`CampusLife.html — ${(page.length / 1024).toFixed(1)} КБ`);
