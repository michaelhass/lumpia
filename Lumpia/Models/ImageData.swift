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

    static func == (left: ImageData, right: ImageData) -> Bool {
        return left.id == right.id
    }
}

extension ImageData {

    /// For testing and previews
    static func testData(withId id: String) -> ImageData {
        let url = URL(string: "https://duckduckgo.com/")!
        let urls = Sizes(regular: url, small: url, thumb: url)
        return .init(id: id,
                     width: 1,
                     height: 1,
                     color: "000000",
                     description: nil,
                     altDescription: nil,
                     urls: urls)
    }
}
