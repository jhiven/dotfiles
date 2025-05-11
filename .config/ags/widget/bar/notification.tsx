import Notifd from "gi://AstalNotifd";
import { bind } from "astal";
import { App } from "astal/gtk3";
import icons from "../../lib/icons";

export function QSButton() {
  return (
    <button
      className="qs-button"
      onClick={() => App.toggle_window("quicksettings")}
      child={<icon className="qs icon" icon={icons.ui.link} />}
    />
  );
}

export function NotificationButton() {
  const notifd = Notifd.get_default();

  return (
    <button
      className={bind(notifd, "notifications").as((notis) => {
        if (notis.length > 0 && !notifd.get_dont_disturb()) {
          return "notify-icon has-notifications";
        }
        return "notify-icon";
      })}
      onClick={() => App.toggle_window("notification-center")}
    >
      <icon
        icon={bind(notifd, "dontDisturb").as((dnd) =>
          dnd ? icons.notification.disabled : icons.notification.default
        )}
      />
    </button>
  );
}
