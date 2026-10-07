<p align="center">
  <img src="docs/images/lumen-icon.png" width="88" alt="Lumen app icon">
</p>

<h1 align="center">Lumen</h1>

<p align="center">Brightness, contrast and volume for every display on your Mac, from the menu bar or your keyboard.</p>

<p align="center"><a href="https://github.com/9phfr6dsw4-dotcom/Lumen/releases/latest"><strong>Download the latest release</strong></a> · macOS 26+ · Apple Silicon</p>

<p align="center">
  <a href="https://github.com/9phfr6dsw4-dotcom/Lumen/releases/latest"><img src="https://img.shields.io/github/v/release/9phfr6dsw4-dotcom/Lumen?display_name=tag" alt="Latest release"></a>
  <img src="https://img.shields.io/badge/macOS-26%2B-black?logo=apple" alt="macOS 26 or later">
  <a href="https://github.com/9phfr6dsw4-dotcom/Lumen/actions/workflows/macos-ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/9phfr6dsw4-dotcom/Lumen/macos-ci.yml?branch=main&amp;label=macOS%20CI" alt="macOS CI status"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License"></a>
</p>

## Features

- Change the brightness of external monitors with their own backlight (DDC), right from the menu bar.
- Monitors that can't be controlled directly (some docks, adapters, TVs, AirPlay and Sidecar) are dimmed in software instead. Lumen works out which is which on its own.
- Dim below a monitor's lowest setting for late nights. The screen never goes fully black.
- Contrast and speaker volume sliders for monitors that support them.
- Your keyboard's brightness keys work on the monitor under the pointer (or on every display), and the volume keys control the monitor's speakers when sound plays through them.
- Presets such as Day, Evening and Night set every display at once, each with its own shortcut.
- Your own shortcuts for brighter and dimmer, a smooth fade between levels, and a small indicator in the corner of the screen you changed.

## Screenshots

![Lumen's menu bar panel with sliders for each display and the Day, Evening and Night presets.](docs/images/lumen-menu-bar.png)

*Menu bar*

![Lumen Displays tab with brightness, contrast and volume for an external monitor and the built-in display.](docs/images/lumen-displays.png)

*Displays*

![Lumen Presets tab with Day, Evening and Night brightness presets.](docs/images/lumen-presets.png)

*Presets*

![Lumen Shortcuts tab for the brightness and volume keys and custom shortcuts.](docs/images/lumen-shortcuts.png)

*Shortcuts*

![Lumen Settings for launch at login, smooth changes, extra dimming and the brightness indicator.](docs/images/lumen-settings.png)

*Settings*

## Install

1. Download `Lumen.zip` from the [latest release](https://github.com/9phfr6dsw4-dotcom/Lumen/releases/latest), unzip it, and move Lumen into Applications.
2. Open it. The builds aren't notarized, so the first time macOS says it can't check the app: open **System Settings → Privacy & Security** and choose **Open Anyway**.
3. Lumen appears in the menu bar as a sun. To use the brightness and volume keys on your monitors, allow Lumen in **System Settings → Privacy & Security → Accessibility** when it asks. After each update, remove the old Lumen entry there and turn on the new one.

## How it works

- **Monitors over DDC:** most external monitors accept brightness, contrast and volume commands over their video cable (DDC/CI). Lumen sends them through macOS's display services on Apple Silicon. Some HDMI ports, docks and adapters don't pass these commands on.
- **Software dimming:** a dark layer over the whole screen. It's used for screens that can't be controlled directly, and for the extra dimming below a monitor's minimum.
- **MacBook and Apple displays:** Lumen uses macOS's own brightness control, and the keyboard keeps working as usual on them.

Lumen has no accounts, no tracking and doesn't connect to the internet.

## Building

GitHub Actions builds, tests and packages the app on macOS 26 (`.github/workflows/macos-ci.yml`). Locally, with Xcode 26:

```sh
swift test
bash Scripts/package-app.sh   # creates dist/Lumen.zip
```

## License

Lumen is under the MIT License.
