//
//  SquaredImage.swift
//  Lumpia
//
//  Created by Michael Haß on 20.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import SwiftUI

struct SquaredImage<Placeholder: View>: View {
    let width: CGFloat
    let url: URL
    private let placeholder: (() -> Placeholder)
    private let cache: Cache<URL, UIImage>?

    init(url: URL,
         width: CGFloat,
         cache: Cache<URL, UIImage>? = nil,
         placeholder: @escaping () -> Placeholder) {

        self.width = width
        self.url = url
        self.cache = cache
        self.placeholder = placeholder
    }

    var body: some View {
        ZStack(alignment: .center) {
            RemoteImage(url: self.url, cache: cache, placeholder: placeholder)
                .aspectRatio(contentMode: .fill)
                .frame(width: self.width, height: self.width, alignment: .center)
                .clipped()
        }.onAppear()
    }
}

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
