# network-panel-ios

Network Panel's native SwiftUI build for iPhone and iPad.
This repository is meant for builds outside the App Store and is designed to produce a self-signable iOS / iPadOS app.

## Current scope

- Native SwiftUI UI
- iPhone and iPad support
- Foreground traffic runner
- Route management and theme switching
- GitHub Actions build on macOS runners

## Important limit

iPadOS background execution is tightly limited. This first version does not promise stable long-running traffic with the screen locked. Foreground testing is the primary path.

## GitHub build

After pushing a tag, Actions will:

1. Install XcodeGen
2. Generate the Xcode project
3. Build with `xcodebuild`
4. Package an unsigned IPA
5. Upload the artifact and create a GitHub Release

## Local Mac build

```bash
brew install xcodegen
xcodegen generate
xcodebuild -project NetworkPanel.xcodeproj -scheme NetworkPanel -configuration Release -sdk iphoneos CODE_SIGNING_ALLOWED=NO build
```

## Safety

Do not commit certificates, keys, provisioning profiles, signed artifacts, or personal screenshots.