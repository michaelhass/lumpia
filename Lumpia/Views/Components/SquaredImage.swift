//
//  SquaredImage.swift
//  Lumpia
//
//  Created by Michael Haß on 20.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import SwiftUI

/// View that displays a remote image in a squared format.
/// The image will be scaled while keeping it's aspect ratio.
/// Content bigger than the desired frame size will be clipped.
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
