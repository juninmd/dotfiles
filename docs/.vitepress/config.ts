import { defineConfig } from "vitepress";

export default defineConfig({
  title: "dotfiles",
  description: "Ambiente de desenvolvimento reproduzível para Windows, macOS e Linux, com instalador TUI oficial.",
  lang: "pt-BR",
  base: "/dotfiles/",
  cleanUrls: true,
  appearance: "dark",
  lastUpdated: true,
  themeConfig: {
    nav: [
      { text: "Download", link: "/download" },
      { text: "Guia", link: "/guide/getting-started" },
      { text: "Catálogo", link: "/catalog" },
      { text: "Sistemas", link: "/os/ubuntu" },
      { text: "Roadmap", link: "/roadmap" },
    ],
    sidebar: [
      { text: "Guia", items: [
        { text: "Começando", link: "/guide/getting-started" },
        { text: "Perfis", link: "/guide/profiles" },
        { text: "Catálogo de módulos", link: "/catalog" },
        { text: "Contribuindo com módulos", link: "/guide/modules" },
        { text: "Ferramentas extras", link: "/guide/extra-tools" },
      ] },
      { text: "Sistemas", items: [
        { text: "Ubuntu", link: "/os/ubuntu" },
        { text: "Tema Ubuntu", link: "/os/ubuntu-theme" },
        { text: "Extensões GNOME", link: "/os/gnome-extensions" },
        { text: "Windows", link: "/os/windows" },
      ] },
      { text: "Apps", items: ["android", "firefox", "mysql", "slack", "vscode", "yarn", "zsh"].map((a) => ({ text: a, link: `/apps/${a}` })) },
      { text: "Projeto", items: [{ text: "Roadmap", link: "/roadmap" }] },
    ],
    socialLinks: [{ icon: "github", link: "https://github.com/juninmd/dotfiles" }],
    search: { provider: "local" },
    editLink: { pattern: "https://github.com/juninmd/dotfiles/edit/master/docs/:path", text: "Editar esta página" },
    footer: { copyright: "© juninmd" },
  },
});
