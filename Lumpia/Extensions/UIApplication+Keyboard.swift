//
//  UIApplication+Keyboard.swift
//  Lumpia
//
//  Created by Michael Haß on 21.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import UIKit

extension UIApplication {
    // Sorry.. Only way that I found to resign from the keyboard within SwiftUI.
    // NOTE: The keyWindow is deprecrated since iOS13.
    func dismissKeyboard() {
        windows.forEach {
            $0.endEditing(true)
        }
    }
}
