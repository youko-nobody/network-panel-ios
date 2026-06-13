#!/usr/bin/env bash
set -euo pipefail

APP_PATH="${1:?app path is required}"
ICON_SET="NetworkPanel/Resources/Assets.xcassets/AppIcon.appiconset"
PLIST="$APP_PATH/Info.plist"

copy_icon() {
  local source_name="$1"
  local target_name="$2"
  cp "$ICON_SET/$source_name" "$APP_PATH/$target_name"
}

copy_icon "Icon-20@2x.png" "AppIcon20x20@2x.png"
copy_icon "Icon-20@3x.png" "AppIcon20x20@3x.png"
copy_icon "Icon-29@2x.png" "AppIcon29x29@2x.png"
copy_icon "Icon-29@3x.png" "AppIcon29x29@3x.png"
copy_icon "Icon-40@2x.png" "AppIcon40x40@2x.png"
copy_icon "Icon-40@3x.png" "AppIcon40x40@3x.png"
copy_icon "Icon-60@2x.png" "AppIcon60x60@2x.png"
copy_icon "Icon-60@3x.png" "AppIcon60x60@3x.png"
copy_icon "Icon-20-ipad.png" "AppIcon20x20~ipad.png"
copy_icon "Icon-20-ipad@2x.png" "AppIcon20x20@2x~ipad.png"
copy_icon "Icon-29-ipad.png" "AppIcon29x29~ipad.png"
copy_icon "Icon-29-ipad@2x.png" "AppIcon29x29@2x~ipad.png"
copy_icon "Icon-40-ipad.png" "AppIcon40x40~ipad.png"
copy_icon "Icon-40-ipad@2x.png" "AppIcon40x40@2x~ipad.png"
copy_icon "Icon-76-ipad.png" "AppIcon76x76~ipad.png"
copy_icon "Icon-76-ipad@2x.png" "AppIcon76x76@2x~ipad.png"
copy_icon "Icon-83.5-ipad@2x.png" "AppIcon83.5x83.5@2x~ipad.png"

/usr/libexec/PlistBuddy -c "Delete CFBundleIcons" "$PLIST" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Add CFBundleIcons dict" "$PLIST"
/usr/libexec/PlistBuddy -c "Add CFBundleIcons:CFBundlePrimaryIcon dict" "$PLIST"
/usr/libexec/PlistBuddy -c "Add CFBundleIcons:CFBundlePrimaryIcon:CFBundleIconFiles array" "$PLIST"
for icon in AppIcon20x20 AppIcon29x29 AppIcon40x40 AppIcon60x60; do
  /usr/libexec/PlistBuddy -c "Add CFBundleIcons:CFBundlePrimaryIcon:CFBundleIconFiles: string $icon" "$PLIST"
done
/usr/libexec/PlistBuddy -c "Add CFBundleIcons:CFBundlePrimaryIcon:CFBundleIconName string AppIcon" "$PLIST"

/usr/libexec/PlistBuddy -c "Delete CFBundleIcons~ipad" "$PLIST" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Add CFBundleIcons~ipad dict" "$PLIST"
/usr/libexec/PlistBuddy -c "Add CFBundleIcons~ipad:CFBundlePrimaryIcon dict" "$PLIST"
/usr/libexec/PlistBuddy -c "Add CFBundleIcons~ipad:CFBundlePrimaryIcon:CFBundleIconFiles array" "$PLIST"
for icon in AppIcon20x20 AppIcon29x29 AppIcon40x40 AppIcon76x76 AppIcon83.5x83.5; do
  /usr/libexec/PlistBuddy -c "Add CFBundleIcons~ipad:CFBundlePrimaryIcon:CFBundleIconFiles: string $icon" "$PLIST"
done
/usr/libexec/PlistBuddy -c "Add CFBundleIcons~ipad:CFBundlePrimaryIcon:CFBundleIconName string AppIcon" "$PLIST"

echo "Bundled icon files:"
find "$APP_PATH" -maxdepth 1 -name 'AppIcon*.png' -print | sort
