//
//  ImageSearchState.swift
//  Lumpia
//
//  Created by Michael Haß on 21.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import Foundation

struct ImageSearchState {

    var status: Status
    var query: String?
    var currentPage: PagedResponse?
    var images: [ImageData]
    var error: Error?

    enum Status {
        case idle
        case fetching
        case success
        case failure
    }

    static var initalState: ImageSearchState {
        return ImageSearchState(status: .idle, images: [])
    }
}
