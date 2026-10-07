import AppKit
import LumenCore
import SwiftUI

@main
@MainActor
struct LumenApp: App {
    @NSApplicationDelegateAdaptor(LumenApplicationDelegate.self) private var applicationDelegate
    @State private var runtime = RunningApp.runtime
    /// The window opens by itself only the first time, so people see what Lumen is.
    private let isFirstLaunch: Bool

    init() {
        let defaults = UserDefaults.standard
        isFirstLaunch = !defaults.bool(forKey: Preferences.hasLaunchedKey)
        defaults.set(true, forKey: Preferences.hasLaunchedKey)
    }

    var body: some Scene {
        MenuBarExtra("Lumen", systemImage: "sun.max.fill") {
            MenuBarView()
                .environment(runtime)
        }
        .menuBarExtraStyle(.window)

        Window("Lumen", id: LumenWindow.main) {
            TabView {
                DisplaysView()
                    .tabItem { Label("Displays", systemImage: "display.2") }
                PresetsView()
                    .tabItem { Label("Presets", systemImage: "sun.horizon") }
                ShortcutsView()
                    .tabItem { Label("Shortcuts", systemImage: "keyboard") }
                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gearshape") }
            }
            .environment(runtime)
            .tint(LumenStyle.blue)
            .navigationTitle("Lumen")
            .onAppear { LumenWindow.didOpen() }
            .onDisappear { LumenWindow.didClose() }
        }
        .defaultSize(width: 920, height: 760)
        .defaultLaunchBehavior(isFirstLaunch ? .presented : .suppressed)
    }
}

/// Lumen lives in the menu bar; it shows a Dock icon only while its window is open.
@MainActor
enum LumenWindow {
    static let main = "main"

    static func didOpen() {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate()
    }

    static func didClose() {
        NSApp.setActivationPolicy(.accessory)
    }
}

@MainActor
final class LumenApplicationDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        RunningApp.runtime.start()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }
}
