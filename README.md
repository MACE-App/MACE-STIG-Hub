<p align="center">
  <img src=".github/images/App_Icon.png" alt="MACE STIG Hub App Icon" width="120" />
</p>

<h1 align="center">MACE STIG Hub</h1>
<p align="center"><strong>Launch STIG Viewer 2 and 3 on macOS — no Java install, no recompiling, no hassle.</strong></p>

<p align="center">
  <img alt="macOS" src="https://img.shields.io/badge/macOS-14%2B-blue?style=flat&logo=apple&logoColor=white" />
  <a href="https://github.com/mace-app/mace-stig-hub/releases">
    <img alt="GitHub release" src="https://img.shields.io/github/v/release/mace-app/mace-stig-hub?style=flat&logo=github&label=Release" />
  </a>
  <a href="https://github.com/mace-app/mace-stig-hub/releases">
    <img alt="Downloads" src="https://img.shields.io/github/downloads/mace-app/mace-stig-hub/total?style=flat&logo=github&label=Downloads" />
  </a>
  <a href="https://github.com/mace-app/mace-stig-hub/blob/main/LICENSE">
    <img alt="License" src="https://img.shields.io/github/license/mace-app/mace-stig-hub?style=flat&label=License" />
  </a>
</p>

## Contents
- [About](#about)
- [Why MACE STIG Hub?](#why-mace-stig-hub)
- [Quick Start](#quick-start)
- [Screenshots](#screenshots)
- [What's Bundled](#whats-bundled)
- [Features](#features)
- [Building from Source](#building-from-source)
- [Requirements](#requirements)
- [Disclaimer](#disclaimer)
- [Community & Feedback](#community--feedback)
- [Credits](#credits)

## About

MACE STIG Hub is a native macOS app that bundles everything you need to run **STIG Viewer 2** (Java) and **STIG Viewer 3** (Electron) — with zero setup. No Java installs, no Homebrew, no recompiling Electron from source. Just open the app and click launch.

**The problem:** Running STIG Viewer on macOS has always been a pain. SV2 requires a Java runtime that Apple no longer ships. SV3 is an Electron app that DISA distributes for Windows and Linux but doesn't officially support on macOS. Getting either one running means hunting down the right JRE, fixing permissions, or extracting and repackaging Electron binaries.

**The solution:** MACE STIG Hub packages both viewers with their dependencies into a single signed and notarized macOS app. It automatically detects your Mac's architecture (Apple Silicon or Intel) and launches the correct version. One download, two viewers, zero configuration.

**Built for:**
- Security Engineers & STIG Assessors
- macOS Administrators
- Government & DoD IT Teams
- Anyone who needs STIG Viewer on a Mac

## Why MACE STIG Hub?

| | |
|---|---|
| **Zero setup** | No Java install, no Homebrew, no terminal commands |
| **Both viewers in one app** | STIG Viewer 2 (Java) and STIG Viewer 3 (Electron) side by side |
| **Universal binary** | Runs natively on Apple Silicon and Intel Macs |
| **Architecture-aware** | Automatically selects the right JRE and Electron build for your chip |
| **Signed & notarized** | Passes Gatekeeper — no need to bypass security warnings |
| **Native macOS app** | Built with SwiftUI for a clean, lightweight experience |
| **Free & open source** | Community-driven, no licensing fees |

## Quick Start

1. **Download** the [latest release](https://github.com/mace-app/mace-stig-hub/releases)
2. **Open** MACE STIG Hub
3. **Click** STIG Viewer 2 or STIG Viewer 3
4. That's it — no configuration needed

## Screenshots

<table>
<tr>
<td align="center">
  <img src=".github/images/light-mode.png" alt="MACE STIG Hub Light Mode" width="420" />
  <p align="center"><em>Light mode</em></p>
</td>
<td align="center">
  <img src=".github/images/dark-mode.png" alt="MACE STIG Hub Dark Mode" width="420" />
  <p align="center"><em>Dark mode</em></p>
</td>
</tr>
</table>

## What's Bundled

| Component | Version | Details |
|-----------|---------|---------|
| **STIG Viewer 2** | v2.18 | Java-based STIG assessment tool (JAR) |
| **STIG Viewer 3** | v3.6 | Electron-based STIG assessment tool |
| **JRE (ARM64)** | Bundled | Java runtime for Apple Silicon Macs |
| **JRE (x64)** | Bundled | Java runtime for Intel Macs |
| **Electron (ARM64)** | Bundled | SV3 build for Apple Silicon Macs |
| **Electron (x64)** | Bundled | SV3 build for Intel Macs |

## Features

### One-Click Launch
- Launch STIG Viewer 2 or 3 with a single click
- Architecture detection automatically selects the correct binaries
- Toast notifications confirm successful launch or report errors

### Fully Self-Contained
- Bundled JRE — no system Java required for STIG Viewer 2
- Bundled Electron app — no recompiling or extracting for STIG Viewer 3
- All dependencies live inside the app bundle

### Native macOS Experience
- Built with SwiftUI for macOS 14+
- Light and dark mode support with adaptive app icon
- Signed with Developer ID and notarized by Apple
- Hardened Runtime enabled for all binaries

### Quick Access Links
- Direct link to DISA STIG/SRG resources
- Link to the project GitHub page

### System Info
- View app version, build info, and system details
- Copy diagnostics to clipboard for troubleshooting

## Building from Source

The `BundledResources/` folder is not included in the repository due to its size (~1.4 GB). To build the project yourself:

1. Download `BundledResources.zip` from the [latest release](https://github.com/mace-app/mace-stig-hub/releases)
2. Unzip it into the project root so the folder structure looks like this:

```
BundledResources/
├── jre-arm64/              # BellSoft Liberica JRE 21 — macOS ARM64 (Apple Silicon)
├── jre-x64/                # BellSoft Liberica JRE 21 — macOS x64 (Intel)
├── STIGViewer-2.18.jar     # STIG Viewer 2 JAR from DISA
├── stigviewer2.icns        # STIG Viewer 2 app icon
├── sv3-arm64/              # STIG Viewer 3.app — macOS ARM64 (Apple Silicon)
│   └── STIG Viewer 3.app/
└── sv3-x64/                # STIG Viewer 3.app — macOS x64 (Intel)
    └── STIG Viewer 3.app/
```

3. Open `MACESTIGHub.xcodeproj` in Xcode
4. Build and run

### Updating components yourself

If you want to update individual components instead of using the pre-built bundle:

| Component | Source |
|-----------|--------|
| **BellSoft Liberica JRE 21** | Download the Full JRE for macOS from [bell-sw.com](https://bell-sw.com/pages/downloads/#jdk-21-lts) — get both `aarch64` and `x86_64` builds |
| **STIGViewer-2.18.jar** | Download from [DISA STIG/SRG Tools](https://cyber.mil/stigs/srg-stig-tools/) — extract the JAR from the zip |
| **STIG Viewer 3** | See [Building STIG Viewer 3 for macOS](#building-stig-viewer-3-for-macos) below |

### Building STIG Viewer 3 for macOS

DISA distributes STIG Viewer 3 as an Electron app for Windows and Linux but not macOS. The macOS version included in this project is built by extracting the application code from the Linux release and repackaging it inside a macOS Electron shell. Here's how:

1. **Download the Linux build** from [DISA STIG/SRG Tools](https://cyber.mil/stigs/srg-stig-tools/) — grab the Linux x64 `.zip`
2. **Extract `app.asar`** — Inside the Linux build, locate `resources/app.asar` and `resources/app.asar.unpacked/`. These contain the STIG Viewer 3 application code and native modules (like `sqlite3-offline-next`)
3. **Download macOS Electron binaries** — Get the matching Electron version for both `darwin-arm64` and `darwin-x64` from [Electron releases](https://github.com/electron/electron/releases). The version must match what DISA built SV3 against
4. **Create the `.app` bundle** — For each architecture:
   - Start with the Electron `.app` from the download (e.g., `Electron.app`)
   - Rename it to `STIG Viewer 3.app`
   - Copy `app.asar` and `app.asar.unpacked/` into `STIG Viewer 3.app/Contents/Resources/`
   - Update `Contents/Info.plist` — set `CFBundleName` to `STIG Viewer 3`, `CFBundleIdentifier` to `com.disa.stigviewer3`, and `CFBundleExecutable` to `STIG Viewer 3`
   - Rename the main executable in `Contents/MacOS/` to `STIG Viewer 3`
5. **Place the builds** in `BundledResources/sv3-arm64/` and `BundledResources/sv3-x64/`

### Code signing the bundled apps

Before archiving for distribution, the SV3 Electron apps must be signed with Hardened Runtime using your Developer ID certificate. Sign all Mach-O binaries inside each `STIG Viewer 3.app` (dylibs, frameworks, helpers, `.node` files) from the inside out, then sign the main `.app` last. An `Electron.entitlements` file is included in the project with the required entitlements for Electron apps.

## Requirements

- **macOS 14.0** (Sonoma) or later
- **Apple Silicon** (M1/M2/M3/M4) or **Intel** Mac
- No additional software required

## Disclaimer

STIG Viewer is developed and published by [DISA](https://www.cyber.mil/stigs/srg-stig-tools/) for the Department of Defense. MACE STIG Hub is an independent, community project that simplifies launching the viewers on macOS. It is **not affiliated with, endorsed by, or supported by DISA or the DoD**.

## Community & Feedback

MACE STIG Hub is a **community-driven project**. If you run into issues, have feature ideas, or just want to share how you're using it:

- Open an [issue](https://github.com/mace-app/mace-stig-hub/issues) for bugs or feature requests
- Start a [discussion](https://github.com/mace-app/mace-stig-hub/discussions) for questions or ideas

## Credits

Created by [Cody Keats](https://codykeats.com) — a Mac admin building tools for the macOS admin community.

Part of the [M.A.C.E.](https://github.com/MACE-App) project family.

<p align="center">
  <a href="https://github.com/mace-app/mace-stig-hub/releases">Download Latest Release</a> &bull;
  <a href="https://github.com/mace-app/mace-stig-hub/issues">Report an Issue</a> &bull;
  <a href="https://github.com/mace-app/mace-stig-hub/discussions">Discussions</a>
</p>
