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

Part of the [M.A.C.E.](https://github.com/MACE-App/MACE) project family.

<p align="center">
  <a href="https://github.com/mace-app/mace-stig-hub/releases">Download Latest Release</a> &bull;
  <a href="https://github.com/mace-app/mace-stig-hub/issues">Report an Issue</a> &bull;
  <a href="https://github.com/mace-app/mace-stig-hub/discussions">Discussions</a>
</p>
