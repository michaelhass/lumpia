//
//  ImageSearchReducerTest.swift
//  LumpiaTests
//
//  Created by Michael Haß on 22.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import XCTest
@testable import Lumpia

class ImageSearchReducerTest: XCTestCase {

    func testExecuteQuery() {
        let query = "This is a test"
        let action = ImageSearchActions.ExecuteQuery(query: query)

        var testState = ImageSearchState.initalState
        testState.images = [.testData(withId: "1")]
        let updatedState = imageSearchReducer(state: testState, action: action)

        // - Status equals .fetching
        // - State properties have to be resetted.
        XCTAssertNotEqual(testState, updatedState)
        XCTAssertEqual(updatedState.status, .fetching)
        XCTAssertEqual(updatedState.query, query)
        XCTAssertNil(updatedState.error)
        XCTAssertNil(updatedState.currentPage)
        XCTAssertTrue(updatedState.images.isEmpty)
    }

    func testFetchNextPage() {

        let testData: [ImageData] = [.testData(withId: "1")]
        let testLinks: [PagedResponse.Link: URL]  = [.next: URL(string: "https://duckduckgo.com/next_2")!]
        let testPage = PagedResponse(response: .init(total: 0, totalPages: 0, results: testData),
                                     links: testLinks)

        var testState: ImageSearchState = ImageSearchState.initalState
        testState.images = testData
        testState.status = .success
        testState.currentPage = testPage

        let action  = ImageSearchActions.FetchNextPage(currentPage: testPage)
        let updatedState = imageSearchReducer(state: testState, action: action)

        // - Status equals .fetching
        // - State properties are transferred from the old state.
        XCTAssertNotEqual(testState, updatedState)
        XCTAssertEqual(updatedState.status, .fetching)
        XCTAssertNil(updatedState.error)
        XCTAssertEqual(updatedState.currentPage, testPage)
        XCTAssertEqual(updatedState.images, testData)
    }

    func testSetSearchResult() {

        let firstPageLinks: [PagedResponse.Link: URL]  = [.next: URL(string: "https://duckduckgo.com/next_2")!]
        let firstPageData: [ImageData] = (0..<10).map { .testData(withId: "\($0)") }
        let firstPage = PagedResponse(response: .init(total: 0, totalPages: 0, results: firstPageData),
                                          links: firstPageLinks)

        let firstPageAction = ImageSearchActions.SetSearchResult(page: firstPage )

        let initialState = ImageSearchState.initalState
        var updatedState = imageSearchReducer(state: initialState, action: firstPageAction)

        // - Status equals .success
        // - Data from the first page is set
        XCTAssertNotEqual(initialState, updatedState)
        XCTAssertEqual(updatedState.status, .success)
        XCTAssertEqual(updatedState.images, firstPageData)
        XCTAssertNil(updatedState.error)
        XCTAssertEqual(updatedState.currentPage, firstPage)

        let secondPageLinks: [PagedResponse.Link: URL]  = [.next: URL(string: "https://duckduckgo.com/next_3")!]
        let secondPageData: [ImageData] = (10..<20).map { .testData(withId: "\($0)") }
        let secondPage = PagedResponse(response: .init(total: 0, totalPages: 0, results: secondPageData),
                                                links: secondPageLinks)

        let secondPageAction = ImageSearchActions.SetSearchResult(page: secondPage )
        updatedState = imageSearchReducer(state: updatedState, action: secondPageAction)

        // - Status equals .success
        // - imageData was append to the existing data
        XCTAssertEqual(updatedState.status, .success)
        XCTAssertEqual(updatedState.images, firstPageData + secondPageData)
        XCTAssertEqual(updatedState.currentPage, secondPage)
        XCTAssertNil(updatedState.error)
        XCTAssertEqual(updatedState.currentPage, secondPage)
    }

    func testShowError() {
        let action = ImageSearchActions.ShowError(error: .noResponse)

        var testState = ImageSearchState.initalState
        testState.images = [.testData(withId: "1")]

        let updatedState = imageSearchReducer(state: testState, action: action)

        // - Status equals .failure
        // - State is resetted.
        XCTAssertEqual(updatedState.status, .failure)
        XCTAssertTrue(updatedState.images.isEmpty)
        XCTAssertNotNil(updatedState.error)
        XCTAssertEqual(updatedState.error, .noResponse)
    }
}
