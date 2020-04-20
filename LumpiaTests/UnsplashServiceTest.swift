//
//  UnsplashServiceTest.swift
//  LumpiaTests
//
//  Created by Michael Haß on 18.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import XCTest
@testable import Lumpia

class UnsplashServiceTest: XCTestCase {

    private let baseURL = URL(string: "https://duckduckgo.com/")!
    private let apiKey = "test_key"
    private var service: UnsplashService {
        .init(baseURL: baseURL, apiKey: apiKey)
    }

    struct TestCodable: Codable { }

    private func testCreateTask(endpoint: UnsplashService.EndPoint, requestURL: URL) {

        let completion: UnsplashService.CompletionHandler<TestCodable> = { _ in }
        let decode: UnsplashService.DecodingHandler<TestCodable> = { data, _ in
            try JSONDecoder().decode(TestCodable.self, from: data)
        }

        guard let task = service.request(endpoint, decode: decode, completion: completion) else {
            XCTFail("Task for search endpoint could not be created")
            return
        }

        guard let request = task.currentRequest else {
            XCTFail("Request for search endpoint could not be created")
            return
        }

        let authHeaderField = request.allHTTPHeaderFields?["Authorization"]
        XCTAssertNotNil(authHeaderField, "Could not find required authorization header field")
        XCTAssertEqual(authHeaderField, "Client-ID \(apiKey)")
        XCTAssertNotNil(request.url, "Could not create URLRequest for endpont: \(endpoint)")
        XCTAssertEqual(requestURL, request.url)
    }

    func testCreateSearchTask() throws {
        let endpoint = UnsplashService.EndPoint.search("search term")
        let requestURL = URL(string: "https://duckduckgo.com/search/photos?query=search%20term")!
        testCreateTask(endpoint: endpoint, requestURL: requestURL)
    }

    func testCreateNextTask() throws {
        let firstURL = baseURL.appendingPathComponent("first")
        let nextURL = baseURL.appendingPathComponent("next")

        let pagedResponse = PagedResponse(response: .init(total: 0, totalPages: 0, results: []),
                                          links: [.first: firstURL, .next: nextURL])

        let endpoint = UnsplashService.EndPoint.next(pagedResponse)
        testCreateTask(endpoint: endpoint, requestURL: nextURL)
    }
}
