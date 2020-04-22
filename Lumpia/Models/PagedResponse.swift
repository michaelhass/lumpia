//
//  PagedResponse.swift
//  Lumpia
//
//  Created by Michael Haß on 19.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import Foundation

/// Wrapper around and paged response retrieved from the unsplash api.
struct PagedResponse: Equatable {
    /// The actual response
    let response: Response
    /// Paging information retrieved from the HTTPResponse header
    let links: [Link: URL]

    init(responseData: Data, httpResponse: HTTPURLResponse) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        response = try decoder.decode(Response.self, from: responseData)
        links = PagedResponse.links(from: httpResponse)
    }

    init(response: Response, links: [Link: URL]) {
        self.response = response
        self.links = links
    }

    /// Creates a dictionary with links from the given HTTPURLResponse.
    /// The format of the links string:
    /// <https://api.unsplash.com/search/photos?page=1&query=hello>; rel="first",
    /// <https://api.unsplash.com/search/photos?page=1&query=hello>; rel="prev",
    /// <https://api.unsplash.com/search/photos?page=1278&query=hello>; rel="last",
    /// <https://api.unsplash.com/search/photos?page=3&query=hello>; rel="next"
    ///
    /// - Parameter response: HTTPURLResponse containing the links string
    /// - Returns: Returns a dictionary with the extracted links.
    static func links(from response: HTTPURLResponse) -> [Link: URL] {
        guard let links = response.allHeaderFields[ResponseHeaderField.link.rawValue] as? String else {
            return [:]
        }
        // Each link is comma separated.
        return links.components(separatedBy: ", ").reduce(into: [Link: URL]()) { (result, element) in
            // Find the value written in rel="_"
            guard let link = Link.allCases.first(where: { element.contains($0.rawValue) }) else { return }
            // Extract the url enclosed in angle brackets '< >'
            guard let range = element.range(of: #"(?<=<)(.*?)(?=>)"#, options: .regularExpression) else { return }
            guard let url = URL(string: String(element[range])) else { return }
            result[link] = url
        }
    }
}

// MARK: - Nested types

extension PagedResponse {

    struct Response: Codable, Equatable {
        let total: Int
        let totalPages: Int
        let results: [ImageData]
    }

    enum Link: String, CaseIterable {
        case first
        case prev
        case last
        case next
    }

    enum ResponseHeaderField: String {
        case link = "Link"
    }
}
