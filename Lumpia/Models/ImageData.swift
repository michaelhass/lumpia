//
//  ImageData.swift
//  Lumpia
//
//  Created by Michael Haß on 19.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import Foundation

/// Image data / information retrieved from the unsplash api.
struct ImageData: Codable, Identifiable, Hashable {

    static func == (left: ImageData, right: ImageData) -> Bool {
        return left.id == right.id
    }

    let id: String
    let width: Int
    let height: Int
    let color: String // Hex color value
    let description: String?
    let altDescription: String?
    let urls: Sizes

    struct Sizes: Codable, Hashable {
        let regular: URL
        let small: URL
        let thumb: URL
    }
}
