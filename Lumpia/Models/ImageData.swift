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
    let createdAt: String
    let likes: Int
    let width: Int
    let height: Int
    let color: String // Hex color value
    let description: String?
    let altDescription: String?
    let urls: Sizes
    let user: User

    struct Sizes: Codable, Hashable {
        let regular: URL
        let small: URL
        let thumb: URL
    }

    struct User: Codable, Hashable, Identifiable {
        let id: String
        let name: String
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
        let user = User(id: "user#1", name: "Name")

        return .init(id: id,
                     createdAt: "2020-04-21T01:03:16-04:00",
                     likes: 55,
                     width: 10000,
                     height: 1000,
                     color: "333333",
                     description: "description",
                     altDescription: nil,
                     urls: urls, user: user)
    }
}
