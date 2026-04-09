import AppKit

enum ScreenGeometry {
    struct NotchBounds {
        let x: CGFloat        // notch left edge
        let y: CGFloat        // notch bottom edge (macOS coords, y goes up)
        let width: CGFloat    // notch width (~185pt)
        let height: CGFloat   // menu bar height (~32pt)

        /// Collapsed: extends DOWN from notch as a pill
        /// Top part (32pt) blends with notch, bottom part (38pt) is visible content
        var collapsed: NSRect {
            let padding: CGFloat = 10
            let visibleHeight: CGFloat = 38  // content area below the notch
            return NSRect(
                x: x - padding,
                y: y - visibleHeight,   // extend downward
                width: width + padding * 2,
                height: height + visibleHeight  // total: 32 (notch) + 38 (content)
            )
        }

        /// Expanded: larger area for permission prompts
        var expanded: NSRect {
            let expandedWidth: CGFloat = 400
            let expandedHeight: CGFloat = 180
            let centerX = x + width / 2
            return NSRect(
                x: centerX - expandedWidth / 2,
                y: y + height - expandedHeight,  // extend down from top
                width: expandedWidth,
                height: expandedHeight
            )
        }

        /// The notch region within the window (for masking/blending)
        var notchHeight: CGFloat { height }
    }

    static func notchBounds(for screen: NSScreen) -> NotchBounds {
        if let leftArea = screen.auxiliaryTopLeftArea,
           let rightArea = screen.auxiliaryTopRightArea {
            let notchX = leftArea.maxX
            let notchWidth = rightArea.minX - leftArea.maxX
            let notchY = leftArea.minY
            let notchHeight = leftArea.height
            return NotchBounds(x: notchX, y: notchY, width: notchWidth, height: notchHeight)
        }

        let topInset = screen.safeAreaInsets.top
        if topInset > 0 {
            let screenFrame = screen.frame
            let notchWidth: CGFloat = 185
            let notchX = screenFrame.midX - notchWidth / 2
            let notchY = screenFrame.maxY - topInset
            return NotchBounds(x: notchX, y: notchY, width: notchWidth, height: topInset)
        }

        return NotchBounds(x: 0, y: 0, width: 0, height: 0)
    }
}
