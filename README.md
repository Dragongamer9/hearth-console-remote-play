# Hearth Console Remote Play

A Hearth Store app: play your own Xbox from anywhere, the way Greenlight does it. Sign in with Microsoft in a window
inside the app, pick your console, and stream it with the graphics card decoding the picture. Made for Hearth OS
(Fedora edition) by Dragongamer9. Version 1.0.

- Install it from the **Hearth Store** on Hearth OS, or download the AppImage from this repository's
  [releases](https://github.com/Dragongamer9/hearth-console-remote-play/releases) and run it.
- The stream uses Hearth OS's own GStreamer (webrtcbin, VA-API); the sign-in window uses its Python and WebKitGTK.
  Your password is typed into Microsoft's own page and never reaches the app.
- The delay is always shown; a data limit (20 GB a month, a warning at 90 %) counts on every network.
- Hold View + Menu for 1 second for the app's menu. Cloud games are an optional tab.

Parts of the stream's input follow Greenlight (MIT): see `LICENSES/greenlight-MIT.txt`. The approved mockups and their
checklist live in Hearth OS (`docs/mockups/console-remote-play`, `docs/CONSOLE-REMOTE-PLAY.md`).

## Building

Built and tested only in GitHub Actions (`.github/workflows/ci.yml`): the build and tests in Fedora 45, every page
against a stand-in for Microsoft's services, the AppImage. It uses Hearth's shared look and widgets (`hearth-ui`) from
Hearth OS at the commit in `hearth-os.ref` (checked out into `hearth-os/`). A release is made by hand (Actions › Hearth
Console Remote Play › Run workflow, "release" ticked) with the version in `Cargo.toml`; the owner picks every version
number.

License: GPL-3.0-or-later (and MIT for the parts noted above).
