<script setup lang="ts">
import { onMounted, ref } from "vue";

type Os = "windows" | "macos" | "linux";
const REL = "https://github.com/juninmd/dotfiles/releases/latest/download";
const SITE = "https://juninmd.github.io/dotfiles";

const targets: Record<Os, { label: string; icon: string; cmd: string; assets: { name: string; file: string }[] }> = {
  windows: { label: "Windows", icon: "🪟", cmd: `irm ${SITE}/install.ps1 | iex`, assets: [{ name: "x64", file: "dotfiles-windows-x64.exe" }] },
  macos: { label: "macOS", icon: "🍎", cmd: `curl -fsSL ${SITE}/install.sh | sh`, assets: [{ name: "Apple Silicon", file: "dotfiles-macos-arm64" }, { name: "Intel", file: "dotfiles-macos-x64" }] },
  linux: { label: "Linux", icon: "🐧", cmd: `curl -fsSL ${SITE}/install.sh | sh`, assets: [{ name: "x64", file: "dotfiles-linux-x64" }, { name: "arm64", file: "dotfiles-linux-arm64" }] },
};

const current = ref<Os>("linux");
const copied = ref(false);

onMounted(() => {
  const ua = navigator.userAgent;
  current.value = /Windows/i.test(ua) ? "windows" : /Mac/i.test(ua) ? "macos" : "linux";
});

async function copy() {
  try {
    await navigator.clipboard.writeText(targets[current.value].cmd);
    copied.value = true;
    setTimeout(() => (copied.value = false), 1500);
  } catch { /* clipboard blocked: command stays selectable */ }
}
</script>

<template>
  <section class="dl">
    <div class="tabs" role="tablist" aria-label="Sistema operacional">
      <button v-for="(t, k) in targets" :key="k" role="tab" :aria-selected="current === k" :class="{ on: current === k }" @click="current = k as Os">
        <span aria-hidden="true">{{ t.icon }}</span> {{ t.label }}
      </button>
    </div>
    <p class="hint">Instalação em uma linha — verifica o SHA-256 antes de executar.</p>
    <div class="cmd">
      <code>{{ targets[current].cmd }}</code>
      <button class="copy" :aria-label="copied ? 'Copiado' : 'Copiar comando'" @click="copy">{{ copied ? "✔ copiado" : "copiar" }}</button>
    </div>
    <p class="hint">Ou baixe o binário direto:</p>
    <div class="assets">
      <a v-for="a in targets[current].assets" :key="a.file" :href="`${REL}/${a.file}`" class="asset">⬇ {{ targets[current].label }} · {{ a.name }}</a>
      <a :href="`${REL}/SHA256SUMS`" class="asset ghost">SHA256SUMS</a>
    </div>
  </section>
</template>

<style scoped>
.dl { border: 1px solid var(--vp-c-divider); border-radius: 16px; padding: 24px; background: var(--vp-c-bg-soft); margin: 24px 0; }
.tabs { display: flex; gap: 8px; flex-wrap: wrap; }
.tabs button { border: 1px solid var(--vp-c-divider); background: var(--vp-c-bg); color: var(--vp-c-text-1); padding: 8px 16px; border-radius: 999px; cursor: pointer; font-weight: 600; }
.tabs button.on { border-color: var(--vp-c-brand-1); color: var(--vp-c-brand-1); }
.tabs button:focus-visible, .copy:focus-visible, .asset:focus-visible { outline: 2px solid var(--vp-c-brand-1); outline-offset: 2px; }
.hint { color: var(--vp-c-text-2); font-size: 14px; margin: 14px 0 8px; }
.cmd { display: flex; gap: 12px; align-items: center; background: #0d0b14; border-radius: 10px; padding: 12px 16px; overflow-x: auto; }
.cmd code { color: #36f9f6; white-space: nowrap; flex: 1; background: none; }
.copy { color: #ff7edb; background: none; border: 1px solid #ff7edb66; border-radius: 6px; padding: 4px 10px; cursor: pointer; }
.assets { display: flex; gap: 10px; flex-wrap: wrap; }
.asset { padding: 8px 14px; border-radius: 8px; background: var(--vp-c-brand-1); color: #1a1022 !important; font-weight: 600; text-decoration: none; }
.asset.ghost { background: transparent; border: 1px solid var(--vp-c-divider); color: var(--vp-c-text-1) !important; }
</style>
