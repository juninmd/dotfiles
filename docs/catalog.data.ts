import { defineLoader } from "vitepress";
import { readFileSync } from "node:fs";

export interface Row { id: string; desc: string; category: string; os: string[] }
declare const data: Row[];
export { data };

export default defineLoader({
  watch: ["../installer/catalog/catalog.json"],
  load(): Row[] {
    const c = JSON.parse(readFileSync(new URL("../installer/catalog/catalog.json", import.meta.url), "utf8"));
    return c.modules.map((m: any) => ({ id: m.id, desc: m.desc, category: m.category, os: Object.keys(m.install) }));
  },
});
