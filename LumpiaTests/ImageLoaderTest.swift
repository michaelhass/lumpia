//
//  ImageLoaderTest.swift
//  LumpiaTests
//
//  Created by Michael Haß on 22.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import XCTest
@testable import Lumpia

class ImageLoaderTest: XCTestCase {

    func testImage() {
        guard let url = Bundle(for: self.classForCoder).url(forResource: "test_image", withExtension: ".jpg") else {
            return XCTFail("Unable to load test image")
        }

        let loader = ImageLoader(url: url)
        let expectImage = XCTestExpectation(description: "Expect to load image")

        _ = loader.objectWillChange
            .subscribe(on: DispatchQueue.main)
            .sink(receiveValue: { image in
                if image != nil {
                    expectImage.fulfill()
                }
            })

        wait(for: [expectImage], timeout: 5)

    }

}
