import { App, Astal, type Gdk, Gtk } from "astal/gtk3";
import { Clock } from "./clock";
import { SysTray } from "./systray";
import { Mpris } from "./mpris";
import { Audio } from "./audio";
import QuickAccessButton from "./quick-access-button";
import { NotificationButton, QSButton } from "./notification";

const LeftModules = (
  <box spacing={8} hexpand halign={Gtk.Align.START}>
    <QSButton />
    {/* <Workspaces />
    <CPU />
    <Mem />
    <FlatpakUpdatesCount /> */}
  </box>
);

const CenterModules = (
  <box spacing={8}>
    <Clock />
    <SysTray />
  </box>
);

const RightModules = (
  <box spacing={8} hexpand halign={Gtk.Align.END}>
    <Mpris />
    {/* <Network /> */}
    <QuickAccessButton />
    <Audio />
    <NotificationButton />
  </box>
);

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

  return (
    <window
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      className="bar"
      anchor={TOP | LEFT | RIGHT}
      application={App}
    >
      <centerbox
        css="min-width: 2px; min-height: 2px;"
        start_widget={LeftModules}
        center_widget={CenterModules}
        end_widget={RightModules}
      />
    </window>
  );
}
