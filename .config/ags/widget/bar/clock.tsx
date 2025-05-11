import { bind, GLib, Variable } from "astal";

const sysTime = Variable(GLib.DateTime.new_now_local()).poll(
  1000,
  (): GLib.DateTime => GLib.DateTime.new_now_local()
);

export function Clock() {
  const time = bind(sysTime).as((value) => value.format("%A, %d %B at %R"));

  return (
    <box className="clock">
      <label className="icon" label=" " css="padding-right: 3px;" />
      <label className="value">{time}</label>
    </box>
  );
}
