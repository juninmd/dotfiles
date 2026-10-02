import type { OS } from "./types";

export function detectOS(p: string = process.platform): OS {
  if (p === "win32") return "windows";
  if (p === "darwin") return "macos";
  return "linux";
}
