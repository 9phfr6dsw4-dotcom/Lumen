import AppKit
import LumenCore
import SwiftUI

/// The panel that opens from Lumen's menu bar icon.
struct MenuBarView: View {
    @Environment(LumenRuntime.self) private var runtime
    @Environment(\.openWindow) private var openWindow

    private var displays: DisplayController { runtime.displays }

    private var activePresetID: UUID? {
        let levels = displays.displays.filter { !$0.isChecking }.map { $0.brightness }
        return BrightnessPresets.active(in: runtime.presets.presets, displayLevels: levels)?.id
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Lumen")
                    .font(.headline)
                Spacer()
                Button {
                    openMainWindow()
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
                .buttonStyle(.borderless)
                .help("Open Lumen")
            }

            if displays.displays.isEmpty {
                Text("No displays found.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(displays.displays) { display in
                    MenuDisplayControls(display: display)
                }
            }

            Divider()

            presetButtons

            if runtime.brightnessKeysEnabled, !runtime.mediaKeys.hasAccessibilityPermission {
                Button {
                    runtime.mediaKeys.requestPermission()
                } label: {
                    Label("Allow Accessibility to use the brightness keys", systemImage: "exclamationmark.triangle.fill")
                        .font(.caption)
                }
                .buttonStyle(.borderless)
                .foregroundStyle(.orange)
            }

            Divider()

            HStack {
                Button("Open Lumen…") { openMainWindow() }
                Spacer()
                Button("Quit Lumen") { NSApp.terminate(nil) }
            }
            .buttonStyle(.borderless)
        }
        .padding(16)
        .frame(width: 330)
        .tint(LumenStyle.blue)
        .onAppear {
            displays.refreshNativeLevels()
            runtime.mediaKeys.refreshPermission()
        }
    }

    private var presetButtons: some View {
        let columns = [GridItem(.adaptive(minimum: 92), spacing: 8)]
        return LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
            ForEach(runtime.presets.presets) { preset in
                let isActive = preset.id == activePresetID
                Button {
                    runtime.apply(preset)
                } label: {
                    Label(preset.name, systemImage: preset.symbolName)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(isActive ? LumenStyle.blue : nil)
                .controlSize(.regular)
            }
        }
    }

    private func openMainWindow() {
        openWindow(id: LumenWindow.main)
        LumenWindow.didOpen()
    }
}

/// One display's sliders in the menu bar panel.
private struct MenuDisplayControls: View {
    @Environment(LumenRuntime.self) private var runtime
    let display: LumenDisplay

    private var displays: DisplayController { runtime.displays }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Text(display.name)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                if display.isChecking {
                    ProgressView()
                        .controlSize(.mini)
                }
            }
            LevelSlider(
                value: display.brightness,
                lowSymbol: "sun.min",
                highSymbol: "sun.max.fill",
                isEnabled: !display.isChecking
            ) { displays.setBrightnessFromSlider($0, for: display) }

            if let contrast = display.contrast {
                LevelSlider(value: contrast, lowSymbol: "circle.lefthalf.filled", highSymbol: "circle.lefthalf.filled", isEnabled: true) {
                    displays.setContrast($0, for: display)
                }
            }
            if let volume = display.volume {
                HStack(spacing: 6) {
                    Button {
                        displays.toggleMute(display)
                    } label: {
                        Image(systemName: volume == 0 ? "speaker.slash.fill" : "speaker.fill")
                            .frame(width: 16)
                    }
                    .buttonStyle(.borderless)
                    .help(volume == 0 ? "Unmute" : "Mute")
                    Slider(value: Binding(get: { volume }, set: { displays.setVolume($0, for: display) }), in: 0 ... 1)
                    Image(systemName: "speaker.wave.3.fill")
                        .foregroundStyle(.secondary)
                        .frame(width: 18)
                }
            }
        }
    }
}

/// A slider with a symbol on each end, used in the menu bar and the window.
struct LevelSlider: View {
    let value: Double
    let lowSymbol: String
    let highSymbol: String
    let isEnabled: Bool
    let onChange: (Double) -> Void

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: lowSymbol)
                .foregroundStyle(.secondary)
                .frame(width: 16)
            Slider(value: Binding(get: { value }, set: { onChange($0) }), in: 0 ... 1)
                .disabled(!isEnabled)
            Image(systemName: highSymbol)
                .foregroundStyle(.secondary)
                .frame(width: 18)
        }
    }
}
