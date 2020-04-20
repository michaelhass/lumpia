//
//  ContentView.swift
//  Lumpia
//
//  Created by Michael Haß on 18.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import SwiftUI

struct GalleryView: View {

    @State var data: [Int] = .init(repeating: 0, count: 40)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    private var numberOfColumns: Int {
        horizontalSizeClass == .compact ? 2 : 4
    }

    private var cellSpacing: CGFloat {
        horizontalSizeClass == .compact ? 6 : 9
    }

    var body: some View {
        CollectionView(data: $data, columns: numberOfColumns, spacing: cellSpacing) { _, width in
            SquaredImage(width: width)
        }
        .padding(.horizontal)
        .background(Color.white)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}
