//
//  Color+Skeleton.swift
//  
//
//  Created by v.prusakov on 10/27/22.
//

import SwiftUI

#if canImport(UIKit)
import UIKit

typealias ESColor = UIColor

#elseif canImport(AppKit)
import AppKit

typealias ESColor = NSColor
#endif

extension Color {
    /// The lighter and darker variants scale brightness by these factors.
    private static let lighterFactor: CGFloat = 1.35
    private static let darkerFactor: CGFloat = 0.9
    /// ITU-R BT.601 luma weights, in thousandths, and the brightness a light color reaches.
    private static let lumaRedWeight: CGFloat = 299
    private static let lumaGreenWeight: CGFloat = 587
    private static let lumaBlueWeight: CGFloat = 114
    private static let lumaWeightTotal: CGFloat = 1000
    private static let lightThreshold: CGFloat = 0.5
    private static let rgbComponentCount = 3

    var complementaryColor: Color {
        isLight ? darker : lighter
    }
    
    var lighter: Color {
        adjust(by: Self.lighterFactor)
    }
    
    var darker: Color {
        adjust(by: Self.darkerFactor)
    }
    
    var isLight: Bool {
        guard let components = self.uiColor.cgColor.components,
              components.count >= Self.rgbComponentCount else { return false }
        let brightness = ((components[0] * Self.lumaRedWeight) + (components[1] * Self.lumaGreenWeight) + (components[2] * Self.lumaBlueWeight)) / Self.lumaWeightTotal
        return !(brightness < Self.lightThreshold)
    }
    
    func adjust(by percent: CGFloat) -> Color {
        // swiftlint:disable:next identifier_name
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return Color(ESColor(hue: h, saturation: s, brightness: b * percent, alpha: a))
    }
    
    public func makeGradient() -> [Color] {
        [self, self.complementaryColor, self]
    }
}

extension Color {
    var uiColor: ESColor {
        ESColor(self)
    }
}


public extension Color {
    /// The macOS skeleton gray, a touch cooler than neutral.
    private static let skeletonGray = (red: 0.82, green: 0.82, blue: 0.84)

    static var skeleton: Color {
#if os(iOS)
        return Color(.systemGray4)
#elseif os(tvOS)
        return Color(.tertiaryLabel)
#elseif os(watchOS)
        return Color.secondary
#elseif os(macOS)
        return Color(NSColor(red: skeletonGray.red, green: skeletonGray.green, blue: skeletonGray.blue, alpha: 1))
#else
        return Color(.tertiaryLabel)
#endif
    }
}
