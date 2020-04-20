//
//  PagedResponseTest.swift
//  LumpiaTests
//
//  Created by Michael Haß on 20.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import XCTest
@testable import Lumpia

class PagedResponseTest: XCTestCase {

    func testLinkParsing() {

        let baseURL = URL(string: "https://duckduckgo.com/")!

        let prevURL = baseURL.appendingPathComponent("prev")
        let lastURL = baseURL.appendingPathComponent("last")
        let firstURL = baseURL.appendingPathComponent("first")
        let nextURL = baseURL.appendingPathComponent("next")

        let linksString = "<\(firstURL.absoluteString)>; rel=\"first\", "
            + "<\(prevURL.absoluteString)>; rel=\"prev\", "
            + "<\(lastURL.absoluteString)>; rel=\"last\", "
            + "<\(nextURL.absoluteString)>; rel=\"next\", "

        let responseHeader = HTTPURLResponse(url: baseURL,
                                             statusCode: 200,
                                             httpVersion: nil,
                                             headerFields: ["Link": linksString])
        
        let extractedLinks = PagedResponse.links(from: responseHeader!)

        let testLinks: [PagedResponse.Link: URL] = [
            .prev: prevURL,
            .last: lastURL,
            .first: firstURL,
            .next: nextURL
        ]

        XCTAssertEqual(extractedLinks, testLinks)
    }


}
