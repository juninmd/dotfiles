---
title: Catálogo
aside: false
---

<script setup>
import { ref, computed } from "vue";
import { data } from "./catalog.data";
const q = ref("");
const rows = computed(() => data.filter((r) => `${r.id} ${r.desc} ${r.category}`.toLowerCase().includes(q.value.toLowerCase())));
const icon = { linux: "🐧", macos: "🍎", windows: "🪟" };
</script>

# Catálogo de módulos

{{ data.length }} módulos. Filtre por nome, categoria ou descrição.

<input v-model="q" type="search" placeholder="Filtrar…" aria-label="Filtrar módulos" style="width:100%;padding:10px 14px;border-radius:10px;border:1px solid var(--vp-c-divider);background:var(--vp-c-bg-soft);color:var(--vp-c-text-1)" />

<p style="color:var(--vp-c-text-2)">{{ rows.length }} resultados</p>

<table>
<thead><tr><th>Módulo</th><th>Categoria</th><th>Descrição</th><th>OS</th></tr></thead>
<tbody>
<tr v-for="r in rows" :key="r.id"><td><code>{{ r.id }}</code></td><td>{{ r.category }}</td><td>{{ r.desc }}</td><td>{{ r.os.map((o) => icon[o]).join(" ") }}</td></tr>
</tbody>
</table>
