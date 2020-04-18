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

    func testCreateSearchTask() throws {
        let service = self.service
        let endpoint = UnsplashService.EndPoint.search("search term")
        let completion: UnsplashService.CompetionHandler<TestCodable> = { _ in }

        guard let task = service.request(endpoint, completion: completion) else {
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
        XCTAssertNotNil(request.url, "Could not create search URLRequestt")
        XCTAssertEqual(URL(string: "https://duckduckgo.com/search/photos?query=search%20term"), request.url)
    }
}
