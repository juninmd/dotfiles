<template>
  <figure class="tui" aria-label="Pré-visualização do instalador em terminal">
    <div class="bar"><i /><i /><i /><span>dotfiles — instalador</span></div>
<pre><span class="d">┌</span>  <span class="tag"> dotfiles </span>  <span class="d">instalador oficial · Linux</span>
<span class="d">│</span>
<span class="c">◆</span>  Escolha um perfil
<span class="d">│</span>  <span class="p">●</span> Dev <span class="d">Minimal + runtimes, containers · 9 apps</span>
<span class="d">│</span>  ○ Minimal
<span class="d">│</span>  ○ AI Dev
<span class="d">│</span>  ○ Personalizado
<span class="d">│</span>
<span class="g">✔</span> git  <span class="g">✔</span> bat  <span class="g">✔</span> ripgrep  <span class="g">✔</span> starship
<span class="p">◒</span> Instalando docker…
<span class="d">└</span>  <span class="d">Tudo pronto ✨</span></pre>
  </figure>
</template>

<style scoped>
.tui { margin: 24px 0; border-radius: 12px; overflow: hidden; background: #0d0b14; border: 1px solid #2a2438; box-shadow: 0 20px 60px #ff7edb22; }
.bar { display: flex; align-items: center; gap: 6px; padding: 10px 14px; background: #171325; color: #8b86a0; font-size: 12px; }
.bar i { width: 11px; height: 11px; border-radius: 50%; background: #ff5f57; }
.bar i:nth-child(2) { background: #febc2e; } .bar i:nth-child(3) { background: #28c840; }
.bar span { margin-left: 10px; }
pre { margin: 0; padding: 16px 18px; color: #e6e1f5; font-size: 13px; line-height: 1.55; overflow-x: auto; }
.d { color: #6e6888; } .c { color: #36f9f6; } .p { color: #ff7edb; } .g { color: #72f1b8; }
.tag { background: #ff7edb; color: #1a1022; }
</style>
