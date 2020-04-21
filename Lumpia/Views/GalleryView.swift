//
//  ContentView.swift
//  Lumpia
//
//  Created by Michael Haß on 18.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import SwiftUI

struct GalleryView: View {

    @State var text: String = ""
    @State var data: [Int] = .init(repeating: 0, count: 40)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    private var numberOfColumns: Int {
        horizontalSizeClass == .compact ? 2 : 3
    }

    private var cellSpacing: CGFloat {
        horizontalSizeClass == .compact ? 6 : 9
    }

    private let textPadding: CGFloat = 12

    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Unsplash").font(.largeTitle)
                        .bold()
                    SearchBar(searchObserver: SearchObserverTest())
                }.padding()

                CollectionView(data: $data, columns: numberOfColumns, spacing: cellSpacing) { _, width in
                    ZStack(alignment: .bottomLeading) {

                        SquaredImage(width: width)

                        LinearGradient(gradient: .init(colors: [Color.black.opacity(0.9), .clear]),
                                       startPoint: .bottom, endPoint: .center)
                            .frame(width: width, height: width)

                        Text("Test a very long sentence for the image cell")
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
                .gesture(DragGesture().onChanged({ _ in UIApplication.shared.dismissKeyboard() }))
                .padding(.horizontal)

            }
                // navigationBarTitle has to be called,
                // else setHidden does not have any effects. -.-
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)

        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}
