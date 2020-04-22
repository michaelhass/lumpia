//
//  ImageCell.swift
//  Lumpia
//
//  Created by Michael Haß on 21.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import SwiftUI

struct ImageCell: View {

    private let preferredWidth: CGFloat
    private let imageData: ImageData?

    init(imageData: ImageData? = nil, preferredWidth: CGFloat) {
        self.preferredWidth = preferredWidth
        self.imageData = imageData
    }

    private let textPadding: CGFloat = 12

    var body: some View {

        ZStack(alignment: .bottomLeading) {

            SquaredImage(width: self.preferredWidth)

            LinearGradient(gradient: .init(colors: [Color.black.opacity(0.9), .clear]),
                           startPoint: .bottom, endPoint: .center)
                .frame(width: self.preferredWidth, height: self.preferredWidth)

            title()
        }
    }

    func title() -> some View {
        let text = imageData?.description ?? imageData?.altDescription ?? ""
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
