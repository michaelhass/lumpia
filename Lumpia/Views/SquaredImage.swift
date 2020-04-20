//
//  SquaredImage.swift
//  Lumpia
//
//  Created by Michael Haß on 20.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import SwiftUI

struct SquaredImage: View {

    let width: CGFloat

    init(width: CGFloat) {
        self.width = width
    }

    var body: some View {
        ZStack(alignment: .center) {
            Image("test_image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: width, alignment: .center)
                .clipped()
        }
    }
}
