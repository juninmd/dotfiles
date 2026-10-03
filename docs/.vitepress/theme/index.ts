import DefaultTheme from "vitepress/theme";
import type { Theme } from "vitepress";
import DownloadCard from "./DownloadCard.vue";
import TuiPreview from "./TuiPreview.vue";
import "./custom.css";

export default {
  extends: DefaultTheme,
  enhanceApp({ app }) {
    app.component("DownloadCard", DownloadCard);
    app.component("TuiPreview", TuiPreview);
  },
} satisfies Theme;
