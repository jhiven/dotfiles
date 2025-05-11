import { App } from "astal/gtk3";

export default function QuickAccessButtons() {
  return (
    <box className="quickaccess-buttons" spacing={15}>
      <button onClicked="niri msg action screenshot" label="" />
    </box>
  );
}
