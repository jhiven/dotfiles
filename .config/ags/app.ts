import { App } from "astal/gtk3";
import Bar from "./widget/bar";
import { exec, monitorFile } from "astal";
import { bash } from "./lib/bash";
import Alert from "./components/alert";
import { NotificationCenter, NotificationPopups } from "./widget/notifications";
import OSD from "./widget/osd";
import QuickSettings from "./widget/quick-settings";

const scss = "./style/style.scss";
const css = "/tmp/ags/style.css";

function reloadCSS() {
  App.reset_css();
  exec(`sass ${scss} ${css}`);
  App.apply_css(css);
}

reloadCSS();

bash("find ./src/style -name '*.scss'").then((out) => {
  for (const path of out.split("\n")) {
    monitorFile(path, () => reloadCSS());
  }
});

App.start({
  css: css,
  main() {
    App.get_monitors().map(Bar);
    Alert();
    NotificationCenter();
    NotificationPopups();
    OSD();
    QuickSettings();
  },
});
