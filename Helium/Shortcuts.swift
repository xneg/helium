//
//  Shortcuts.swift
//  Helium
//
//  Created by khang on 7/4/23.
//

import Cocoa
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let toggleMode = Self("toggleMode")
    static let setPrecisionMode = Self("setPrecisionMode")
    static let setFullscreenMode = Self("setFullscreenMode")
}

enum Action: Int {
    case toggleMode = 1
    case toggleBounds = 2
    case setFullscreen = 3
    case setPrecision = 4
    case openPreferences = 5
    case quit = 6

    var name: String {
        switch self {
        case .toggleMode: return "toggleMode"
        case .toggleBounds: return "toggleBounds"
        case .setFullscreen: return "setFullscreen"
        case .setPrecision: return "setPrecision"
        case .openPreferences: return "openPreferences"
        case .quit: return "quit"
        }
    }

    var displayName: String {
        switch self {
        case .toggleMode: return "Toggle Mode"
        case .toggleBounds: return "Toggle Bounds"
        case .setFullscreen: return "Use Fullscreen Mode"
        case .setPrecision: return "Use Precision Mode"
        case .openPreferences: return "Preferences…"
        case .quit: return "Quit Helium"
        }
    }
}
