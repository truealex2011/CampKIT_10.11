import { OceanEngine, type SharkSpec } from "./src";

const canvas = document.querySelector<HTMLCanvasElement>("#ocean")!;
const toastEl = document.querySelector<HTMLElement>("#toast")!;
const byId = <T extends HTMLElement>(id: string) => document.getElementById(id) as T;
const roster: SharkSpec[] = [
  { kind: "classic", size: 1.5 },
  { kind: "tiger", size: 1.18 },
  { kind: "mako", size: 1.02 },
  { kind: "hammerhead", size: 0.88 },
  { kind: "zebra", size: 0.78 },
  { kind: "nurse", size: 0.72 },
  { kind: "mako", size: 0.66 },
];
new OceanEngine(canvas, roster);

const plural = (n: number, one: string, few: string, many: string) => {
  const tail = n % 100;
  if (tail >= 11 && tail <= 14) return many;
  const last = n % 10;
  if (last === 1) return one;
  return last >= 2 && last <= 4 ? few : many;
};

byId("live-count").textContent = `${roster.length} ${plural(roster.length, "рыба", "рыбы", "рыб")}`;

let toastTimer = 0;
function toast(message: string) {
  toastEl.textContent = message;
  toastEl.classList.add("show");
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => toastEl.classList.remove("show"), 2800);
}

function switcher(seg: HTMLElement, host: HTMLElement) {
  const buttons = Array.from(seg.querySelectorAll<HTMLElement>("[data-tab]"));
  const panes = Array.from(host.children) as HTMLElement[];
  const select = (name: string) => {
    for (const b of buttons) b.setAttribute("aria-selected", String(b.dataset.tab === name));
    for (const p of panes) p.hidden = p.getAttribute("data-pane") !== name;
    syncWizard();
  };
  for (const b of buttons) b.addEventListener("click", () => select(b.dataset.tab!));
  return { select };
}

const auth = switcher(byId("auth-tabs"), byId("auth-host"));
switcher(byId("role-tabs"), byId("role-host"));
switcher(byId("org-tabs"), byId("org-host"));


document.querySelectorAll<HTMLElement>("[data-stub]").forEach((b) => {
  b.addEventListener("click", () => toast(`«${b.dataset.stub}» — заглушка: экран по ТЗ ещё не сделан`));
});

const emailRe = /^[^\s@]+@[^\s@]+\.[a-z]{2,}$/i;
const phoneRe = /^\+?[78][\s(-]?\d{3}[)\s-]?\d{3}[\s-]?\d{2}[\s-]?\d{2}$/;

const fieldsIn = (root: HTMLElement) =>
  Array.from(root.querySelectorAll<HTMLInputElement | HTMLSelectElement>("input, select"));

const filled = (f: HTMLInputElement | HTMLSelectElement) => f.value.trim() !== "";

function problem(f: HTMLInputElement | HTMLSelectElement): string {
  const v = f.value.trim();
  if (!filled(f)) return f.hasAttribute("required") ? "Обязательное поле" : "";
  if (f.type === "email") return emailRe.test(v) ? "" : "Не похоже на почту";
  if (f.dataset.phone !== undefined) return phoneRe.test(v) ? "" : "Не похоже на телефон (+7 900 123-45-67)";
  if (f.type === "password") return v.length >= 6 ? "" : "Минимум 6 символов";
  return "";
}

function paint(f: HTMLInputElement | HTMLSelectElement) {
  const text = problem(f);
  f.classList.toggle("bad", !!text);
  const hint = f.closest(".field")?.querySelector<HTMLElement>(".hint");
  if (hint) hint.textContent = text;
}

const ready = (group: HTMLElement) => fieldsIn(group).every((f) => !problem(f));

const steps = Array.from(document.querySelectorAll<HTMLElement>("[data-step]"));
const dots = Array.from(document.querySelectorAll<HTMLElement>("[data-dot]"));
let step = 0;

const STRENGTH = ["пароль", "слабый", "средний", "хороший", "надёжный"];

function score(value: string) {
  let s = 0;
  if (value.length >= 6) s++;
  if (value.length >= 10) s++;
  if (/\d/.test(value) && /[a-zа-я]/i.test(value)) s++;
  if (/[A-ZА-Я]/.test(value) && /[^\w\s]/.test(value)) s++;
  return s;
}

const meter = byId("su-strength");
const pass = byId<HTMLInputElement>("su-pass");

function showStrength() {
  const s = pass.value ? score(pass.value) : 0;
  meter.className = `strength${s ? ` lvl-${s}` : ""}`;
  meter.querySelector("b")!.textContent = STRENGTH[s];
}

pass.addEventListener("input", showStrength);

document.querySelectorAll<HTMLElement>("[data-reveal]").forEach((b) => {
  b.addEventListener("click", () => {
    const input = byId<HTMLInputElement>(b.dataset.reveal!);
    const shown = input.type === "password";
    input.type = shown ? "text" : "password";
    b.setAttribute("aria-expanded", String(shown));
    b.setAttribute("aria-label", shown ? "Скрыть пароль" : "Показать пароль");
    input.focus();
  });
});

function syncWizard() {
  const current = steps[step];
  if (!current) return;
  const ok = ready(current);
  byId<HTMLButtonElement>("wizard-next").disabled = !ok;
  byId<HTMLButtonElement>("wizard-submit").disabled = !ok;
}

function showStep(i: number) {
  step = i;
  for (const el of steps) el.hidden = Number(el.dataset.step) !== i;
  for (const d of dots) {
    const n = Number(d.dataset.dot);
    if (n === i) d.setAttribute("aria-current", "step");
    else if (n < i) d.setAttribute("aria-current", "true");
    else d.removeAttribute("aria-current");
  }
  byId("wizard-progress").textContent = `${i + 1} из ${steps.length}`;
  byId("wizard-fill").style.width = `${((i + 1) / steps.length) * 100}%`;
  byId<HTMLButtonElement>("wizard-back").disabled = i === 0;
  syncWizard();
}

function goNext() {
  fieldsIn(steps[step]).forEach(paint);
  if (!ready(steps[step])) return void toast("Заполни поля этого шага");
  showStep(Math.min(step + 1, steps.length - 1));
}

byId("wizard-next").addEventListener("click", goNext);
byId("wizard-back").addEventListener("click", () => showStep(Math.max(step - 1, 0)));

byId<HTMLInputElement>("org-key").addEventListener("keydown", (e) => {
  if (e.key === "Enter") {
    e.preventDefault();
    goNext();
  }
});

for (const form of Array.from(document.querySelectorAll<HTMLFormElement>("form"))) {
  form.addEventListener("submit", (e) => {
    e.preventDefault();
    const fields = fieldsIn(form).filter((f) => !f.closest("[hidden]"));
    fields.forEach(paint);
    if (fields.some((f) => problem(f))) return toast("Проверь отмеченные поля");
    toast("Заглушка: сервер FastAPI ещё не поднят — данные никуда не уходят");
  });
  form.addEventListener("input", (e) => {
    const f = e.target;
    if (f instanceof HTMLInputElement || f instanceof HTMLSelectElement) paint(f);
    syncWizard();
  });
}

const TEST_ACCOUNTS: Record<string, [string, string]> = {
  member: ["uchastnik@campus.life", "test123"],
  organizer: ["organizator@campus.life", "test123"],
  admin: ["admin@campus.life", "test123"],
};

document.querySelectorAll<HTMLElement>("[data-test]").forEach((b) => {
  b.addEventListener("click", () => {
    const [id, pass] = TEST_ACCOUNTS[b.dataset.test!];
    auth.select("login");
    byId<HTMLInputElement>("login-id").value = id;
    byId<HTMLInputElement>("login-pass").value = pass;
    paint(byId<HTMLInputElement>("login-id"));
    paint(byId<HTMLInputElement>("login-pass"));
    toast(`Подставлен тестовый аккаунт: ${b.dataset.test}`);
  });
});

showStep(0);
if (location.hash === "#signup") auth.select("signup");
