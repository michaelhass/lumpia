//
//  ImageData.swift
//  Lumpia
//
//  Created by Michael Haß on 19.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import Foundation

/// Image data / information retrieved from the unsplash api.
struct ImageData: Codable, Identifiable {
    let id: String
    let width: Int
    let height: Int
    let color: String // Hex color value
    let description: String?
    let altDescription: String?
    let urls: Sizes

    struct Sizes: Codable {
        let regular: URL
        let small: URL
        let thumb: URL
    }
}
