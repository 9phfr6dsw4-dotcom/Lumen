import Foundation

/// UserDefaults keys for Lumen's settings.
enum Preferences {
    static let extraDimmingKey = "Lumen.extraDimming"
    static let smoothChangesKey = "Lumen.smoothChanges"
    static let linkDisplaysKey = "Lumen.linkDisplays"
    static let showIndicatorKey = "Lumen.showIndicator"
    static let brightnessKeysKey = "Lumen.brightnessKeys"
    static let brightnessKeyTargetKey = "Lumen.brightnessKeyTarget"
    static let volumeKeysKey = "Lumen.volumeKeys"
    static let presetsKey = "Lumen.presets"
    static let brighterShortcutKey = "Lumen.shortcut.brighter"
    static let dimmerShortcutKey = "Lumen.shortcut.dimmer"
    static let hasLaunchedKey = "Lumen.hasLaunched"
    static let launchAtLoginKey = "Lumen.launchAtLogin"

    static func displayKey(_ storageKey: String, _ setting: String) -> String {
        "Lumen.display.\(storageKey).\(setting)"
    }

    /// A Bool setting that's on until the user turns it off.
    static func isOn(_ key: String, defaultValue: Bool = true, defaults: UserDefaults = .standard) -> Bool {
        defaults.object(forKey: key) as? Bool ?? defaultValue
    }
}
