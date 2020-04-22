//
//  Color+Hex.swift
//  Lumpia
//
//  Created by Michael Haß on 22.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import SwiftUI

extension Color {

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)

        var intValue = UInt64()
        Scanner(string: hex).scanHexInt64(&intValue)

        let alpha, red, green, blue: UInt64

        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (intValue >> 8) * 17, (intValue >> 4 & 0xF) * 17, (intValue & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, intValue >> 16, intValue >> 8 & 0xFF, intValue & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (intValue >> 24, intValue >> 16 & 0xFF, intValue >> 8 & 0xFF, intValue & 0xFF)
        default:
            (alpha, red, green, blue) = (1, 1, 1, 0)
        }

        self.init(UIColor(red: CGFloat(red) / 255,
                          green: CGFloat(green) / 255,
                          blue: CGFloat(blue) / 255,
                          alpha: CGFloat(alpha) / 255)
        )
    }
}
