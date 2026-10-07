import AppKit
import LumenCore
import SwiftUI

struct SettingsView: View {
    @Environment(LumenRuntime.self) private var runtime
    @AppStorage(Preferences.smoothChangesKey) private var smoothChanges = true
    @AppStorage(Preferences.extraDimmingKey) private var extraDimming = true
    @AppStorage(Preferences.linkDisplaysKey) private var linkDisplays = false
    @AppStorage(Preferences.showIndicatorKey) private var showIndicator = true

    private var launchAtLogin: LaunchAtLoginController { runtime.launchAtLogin }

    private var versionText: String {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "–"
        let build = info?["CFBundleVersion"] as? String ?? "–"
        return "Lumen \(version) (build \(build))"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Settings")
                        .font(.largeTitle.weight(.semibold))
                    Text("Choose how Lumen starts and how brightness changes.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }

                generalSettings
                brightnessSettings
                aboutSection

                Label("Lumen works entirely on this Mac. It has no accounts, no tracking and doesn't connect to the internet.", systemImage: "lock.shield")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(28)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .background(Color(nsColor: .windowBackgroundColor))
        .frame(minWidth: 760, minHeight: 580)
        .onAppear { launchAtLogin.refreshStatus() }
        .onChange(of: extraDimming) { runtime.displays.reapplyAll() }
    }

    private var generalSettings: some View {
        GroupBox("General") {
            VStack(alignment: .leading, spacing: 8) {
                Toggle("Open Lumen when you log in", isOn: Binding(
                    get: { launchAtLogin.isEnabled },
                    set: { launchAtLogin.setEnabled($0) }
                ))
                Text("Lumen stays in the menu bar. Its window and Dock icon only appear when you open them.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                if let message = launchAtLogin.statusMessage {
                    HStack(alignment: .firstTextBaseline) {
                        Label(message, systemImage: "exclamationmark.triangle.fill")
                            .font(.caption)
                            .foregroundStyle(.red)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                        Button("Open Login Items") { launchAtLogin.openLoginItemsSettings() }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
        }
    }

    private var brightnessSettings: some View {
        GroupBox("Brightness") {
            VStack(alignment: .leading, spacing: 10) {
                Toggle("Smooth brightness changes", isOn: $smoothChanges)
                Text("Brightness glides to its new level instead of jumping.")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Divider()

                Toggle("Dim below the monitor's lowest setting", isOn: $extraDimming)
                Text("The bottom quarter of the slider dims the picture further once the monitor's own brightness reaches its minimum. The screen never goes fully black.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                Divider()

                Toggle("Move all displays together", isOn: $linkDisplays)
                Text("Any brightness slider or key changes every display to the same level.")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Divider()

                Toggle("Show the brightness indicator", isOn: $showIndicator)
                Text("A small bar in the top-right corner of the screen you changed, when you use keys, shortcuts or presets.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
        }
    }

    private var aboutSection: some View {
        GroupBox("About") {
            VStack(alignment: .leading, spacing: 6) {
                Text(versionText)
                    .font(.headline)
                Text("Brightness, contrast and volume for every display on your Mac. Monitors are controlled directly over DDC where they support it, and dimmed in software where they don't.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                Link("Lumen on GitHub", destination: URL(string: "https://github.com/9phfr6dsw4-dotcom/Lumen")!)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
        }
    }
}
