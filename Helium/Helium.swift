//
//  Helium.swift
//  Helium
//
//  Created by khang on 7/4/23.
//

import Cocoa

/**
 * Wraps Wacom with Helium's app state.
 * This includes preferences and running-state variables such as last-used tablet.
 */
class Helium: Store {
    var showBounds: Pair<String>
    var mode: Mode
    var lastUsedTablet = Ref(0) // initialize with invalid tablet ID
    let overlay: Overlay

    override init() {
        self.showBounds = Pair(on: "Hide Bounds", off: "Show Bounds", true)
        self.mode = .fullscreen
        self.overlay = Overlay()
        super.init()
    }

    func showOverlay() { if mode == .precision, showBounds.on { overlay.show() } }
    func hideOverlay() { overlay.hide() }
    func toggleMode() { mode.next(); refresh() }
    func refresh() { mode == .precision ? setPrecisionMode() : setFullScreenMode() }

    /** Make the tablet cover the area around the cursor's current location. */
    func setPrecisionMode() {
        mode = .precision
        let frame = NSScreen.current().frame
        let area = frame.precision(at: NSEvent.mouseLocation, scale: scale, aspectRatio: aspectRatio)
        setTablet(to: area)
        moveOverlay(to: area)
        overlay.flash()
    }

    /** Make the tablet cover the whole screen that contains the user's cursor. */
    func setFullScreenMode() {
        mode = .fullscreen
        let frame = NSScreen.current().frame
        var area = frame.fill(withAspectRatio: aspectRatio)
        setTablet(to: area)
        overlay.fullscreen(to: &area, lineColor: lineColor, lineWidth: lineWidth, cornerLength: cornerLength)
        overlay.flash()
    }

    /** Rehydrate running state after settings have changed */
    func reloadSettings() {
        let cursor = NSEvent.mouseLocation
        let area = NSScreen.current().frame.precision(at: cursor, scale: scale, aspectRatio: aspectRatio)
        moveOverlay(to: area)
        overlay.flash()
    }

    /** Move overlay to cover target NSRect */
    private func moveOverlay(to rect: NSRect) {
        overlay.set(to: rect, lineColor: lineColor, lineWidth: lineWidth, cornerLength: cornerLength)
    }

    /**
     * Sends a WacomTabletDriver API call to override tablet map area.
     * Also makes the overlay follow wherever it goes.
     */
    private func setTablet(to rect: NSRect) {
        ObjCWacom.setScreenMapArea(rect, tabletId: Int32(lastUsedTablet.val))
    }

    /** Reset screen map area to current screen. For use upon exiting. */
    func reset() {
        ObjCWacom.setScreenMapArea(NSScreen.main!.frame, tabletId: Int32(lastUsedTablet.val))
    }
}
