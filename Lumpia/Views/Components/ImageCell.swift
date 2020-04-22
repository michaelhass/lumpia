//
//  ImageCell.swift
//  Lumpia
//
//  Created by Michael Haß on 21.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import SwiftUI

// Cell for GalleryView. Square image with title.
struct ImageCell: View {

    let preferredWidth: CGFloat
    let imageData: ImageData

    private let cache: Cache<URL, UIImage>?
    private var action: ((ImageData) -> Void)?

    init(imageData: ImageData,
         preferredWidth: CGFloat,
         cache: Cache<URL, UIImage>? = shared?.imageCache,
         action: @escaping (ImageData) -> Void) {

        self.preferredWidth = preferredWidth
        self.imageData = imageData
        self.cache = cache
        self.action = action
    }

    private let textPadding: CGFloat = 12

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            SquaredImage(url: self.imageData.urls.small, width: self.preferredWidth, cache: cache) {
                Rectangle().fill(Color(hex: self.imageData.color))
            }

            LinearGradient(gradient: .init(colors: [Color.black.opacity(0.9), .clear]),
                           startPoint: .bottom, endPoint: .center)
                .frame(width: self.preferredWidth, height: self.preferredWidth)

            title()
        }.onTapGesture {
            self.action?(self.imageData)
        }
    }

    /// Creates a title view displaying the description of
    /// the image data if available.
    func title() -> some View {
        let text = imageData.description ?? imageData.altDescription ?? ""
        return Text(text)
            .fontWeight(.medium)
            .font(.caption)
            .kerning(1.0)
            .foregroundColor(.white)
            .lineLimit(2)
            .padding(.init(top: 0,
                           leading: self.textPadding,
                           bottom: self.textPadding,
                           trailing: self.textPadding))
    }
}
