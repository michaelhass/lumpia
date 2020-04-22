//
//  RemoteImage.swift
//  Lumpia
//
//  Created by Michael Haß on 22.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import SwiftUI

// Displays an image received from the given url.
struct RemoteImage<Placeholder: View>: View {

    @ObservedObject private var loader: ImageLoader
    private let placeholder: (() -> Placeholder)

    init(url: URL, cache: Cache<URL, UIImage>? = nil, placeholder: @escaping () -> Placeholder) {
        loader = ImageLoader(url: url, cache: cache)
        self.placeholder = placeholder
    }

    var body: some View {
        ZStack {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()

            } else {
                placeholder()
            }
        }
    }
}
