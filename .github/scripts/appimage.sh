#!/bin/bash
# Makes this app's AppImage, the file the Hearth Store installs (asset "*-x86_64.AppImage" and SHA256SUMS.txt on a
# release; hearth-os docs/HEARTH-STORE.md). The app uses Hearth OS's own GStreamer (and, for Remote Play's sign-in
# window, its Python and WebKitGTK), so the AppImage carries only the app: built in Fedora 45, as Hearth OS is.
#   appimage.sh BIN "Name" "LETTERS" "#from" "#to" [extra files for usr/bin...]
# Out: dist/<Name-with-dashes>-<version>-x86_64.AppImage and dist/SHA256SUMS.txt
set -euo pipefail
BIN="$1"; NAME="$2"; LETTERS="$3"; FROM="$4"; TO="$5"; shift 5
VER=$(sed -n 's/^version = "\(.*\)"/\1/p' Cargo.toml | head -1)
[ -n "$VER" ] || { echo "::error title=AppImage::no version in Cargo.toml"; exit 1; }
FILE="$(echo "$NAME" | tr ' ' '-')-$VER-x86_64.AppImage"
D=AppDir; rm -rf "$D" dist; mkdir -p "$D/usr/bin" dist
install -m755 "bin/$BIN" "$D/usr/bin/$BIN"
for f in "$@"; do install -m755 "$f" "$D/usr/bin/$(basename "$f")"; done
cat > "$D/AppRun" <<RUN
#!/bin/sh
HERE="\$(dirname "\$(readlink -f "\$0")")"
exec "\$HERE/usr/bin/$BIN" "\$@"
RUN
chmod 755 "$D/AppRun"
cat > "$D/$BIN.desktop" <<DESK
[Desktop Entry]
Type=Application
Name=$NAME
Exec=$BIN
Icon=$BIN
Categories=AudioVideo;Game;
Terminal=false
StartupWMClass=$BIN
DESK
cat > "$D/$BIN.svg" <<SVG
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256"><defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="$FROM"/><stop offset="1" stop-color="$TO"/></linearGradient></defs><rect width="256" height="256" rx="56" fill="url(#g)"/><text x="128" y="160" font-family="sans-serif" font-weight="800" font-size="104" text-anchor="middle" fill="#fff">$LETTERS</text></svg>
SVG
ln -sf "$BIN.svg" "$D/.DirIcon"
curl -fsSL -o /tmp/appimagetool https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x /tmp/appimagetool
ARCH=x86_64 /tmp/appimagetool --appimage-extract-and-run --no-appstream "$D" "dist/$FILE" >/tmp/ait.log 2>&1 || { tail -20 /tmp/ait.log | while read -r l; do echo "::error title=appimagetool::$l"; done; exit 1; }
(cd dist && sha256sum "$FILE" > SHA256SUMS.txt)
echo "::notice title=AppImage::$FILE ($(du -h "dist/$FILE" | cut -f1)), sha256 $(cut -c1-16 dist/SHA256SUMS.txt)…"
