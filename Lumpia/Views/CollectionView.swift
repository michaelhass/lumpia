//
//  CollectionView.swift
//  Lumpia
//
//  Created by Michael Haß on 20.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import SwiftUI

struct CollectionView<Cell: View, Data: Hashable>: View {

    /// Number of columns
    let columns: Int
    /// Spacing between each cell
    let spacing: CGFloat
    /// Whether the scrollView should show scroll indicators
    let showsIndicators: Bool

    // Returns a cell for the given data
    private let cellForData: (Data, CGFloat) -> Cell
    // The data source of the collection
    @Binding private var data: [Data]

    init(data: Binding<[Data]>,
         columns: Int,
         spacing: CGFloat,
         showsIndicators: Bool = false,
         cellForData: @escaping (Data, CGFloat) -> Cell) {

        _data = data
        self.columns = columns
        self.spacing = spacing
        self.showsIndicators = showsIndicators
        self.cellForData = cellForData
    }

    var body: some View {
         GeometryReader { geometry in
            ScrollView(showsIndicators: self.showsIndicators) {
                self.createCells(geometry: geometry)
            }
         }
    }

    private func createCells(geometry: GeometryProxy) -> some View {

        let rows = data.count / columns + (data.count % columns == 0 ? 0 : 1)

        let frame = geometry.frame(in: .global)
        let totalSpacing = spacing * CGFloat(columns - 1)
        let cellWidth = (frame.width - totalSpacing) / CGFloat(columns)

        return VStack(alignment: .leading, spacing: spacing) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: self.spacing) {
                    ForEach(0..<self.columns, id: \.self) { column in
                        self.cell(forRow: row, column: column, availableWidth: cellWidth)
                            .frame(maxWidth: cellWidth)
                    }
                }
            }
            // Pushes the content to the top, if there
            // are not enough cells to fill the entire screen.
            Spacer()
        }.frame(minHeight: geometry.frame(in: .global).height) // Expand the VStack over the entire frame
    }

    private func cell(forRow row: Int, column: Int, availableWidth: CGFloat) -> some View {
        let index = row * columns + column
        return ZStack {
            index < self.data.count ? cellForData(data[index], availableWidth) : nil
        }

    }
}
