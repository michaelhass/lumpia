//
//  PagedResponse.swift
//  Lumpia
//
//  Created by Michael Haß on 19.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import Foundation

struct PagedResponse {
    let totalCount: Int
    let perPageCount: Int
    let results: [ImageData]

    private enum HeaderField: String {
        case totalCount = "X-Total"
        case perPageCount = "X-Per-Page"
    }

    init(response: HTTPURLResponse, resultsData: Data) throws {
        self.totalCount = try PagedResponse.headerValue(for: .totalCount, in: response)
        self.perPageCount = try PagedResponse.headerValue(for: .perPageCount, in: response)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.results = try decoder.decode([ImageData].self, from: resultsData)
    }

    private static func headerValue<T>(for headerField: HeaderField,
                                       in response: HTTPURLResponse) throws -> T {

        guard let value = response.allHeaderFields[headerField.rawValue] as? T else {
            throw ServiceError.missingResponseHeaderField(headerField.rawValue)
        }
        return value
    }
}
