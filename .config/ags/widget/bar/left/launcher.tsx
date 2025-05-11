// import { GLib } from "astal";
// import { App, Astal, type Gdk, Gtk } from "astal/gtk3";
// import icons from "~/lib/icons";

// // function Spinner() {
// //     const child = Widget.Icon({
// //         icon: icon.icon.bind(),
// //         class_name: Utils.merge([
// //             icon.colored.bind(),
// //             nix.bind("ready"),
// //         ], (c, r) => `${c ? "colored" : ""} ${r ? "" : "spinning"}`),
// //         css: `
// //             @keyframes spin {
// //                 to { -gtk-icon-transform: rotate(1turn); }
// //             }
// //             image.spinning {
// //                 animation-name: spin;
// //                 animation-duration: 1s;
// //                 animation-timing-function: linear;
// //                 animation-iteration-count: infinite;
// //             }
// //         `,
// //     })
// //     return Widget.Revealer({
// //         transition: "slide_left",
// //         child,
// //         reveal_child: Utils.merge([
// //             icon.icon.bind(),
// //             nix.bind("ready"),
// //         ], (i, r) => Boolean(i || r)),
// //     })
// // }

// function Spinner(gdkmonitor: Gdk.Monitor) {
//   const logo = GLib.get_os_info("LOGO");

//   return (
//     <revealer
//       transitionType={Gtk.RevealerTransitionType.SLIDE_LEFT}
//       revealChild
//       setup={self => timeout(500, () => self.revealChild = true)}
//     >
//       <icon
//         icon={logo ?? icons.ui.menu}
//         css={`
//           @keyframes spin {
//             to {
//               -gtk-icon-transform: rotate(1turn);
//             }
//           }

//           image.spinning {
//             animation-name: spin;
//             animation-duration: 1s;
//             animation-timing-function: linear;
//             animation-iteration-count: infinite;
//           }
//         `}
//       />
//     </revealer>
//   );
// }

// export default () =>
//   PanelButton({
//     window: "launcher",
//     on_clicked: action.bind(),
//     child: Widget.Box([
//       Spinner(),
//       Widget.Label({
//         class_name: label.colored.bind().as((c) => (c ? "colored" : "")),
//         visible: label.label.bind().as((v) => !!v),
//         label: label.label.bind(),
//       }),
//     ]),
//   });
