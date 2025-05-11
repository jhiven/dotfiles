import { GLib } from "astal";

export const fileExists = (path: string) =>
  GLib.file_test(path, GLib.FileTest.EXISTS);
