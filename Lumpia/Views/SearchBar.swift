//
//  SearchBar.swift
//  Lumpia
//
//  Created by Michael Haß on 21.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import SwiftUI

struct SearchBar: View {
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")

            TextField("search", text: $searchText, onEditingChanged: { _ in
                self.showCancelButton = true
            }, onCommit: {
                print("onCommit")
            }).foregroundColor(.primary)

            Button(action: {
                self.searchText = ""
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .opacity(searchText == "" ? 0 : 1)
            })
            if showCancelButton {
                Button("Cancel") {
                    UIApplication.shared.dismissKeyboard()
                    self.searchText = ""
                    self.showCancelButton = false
                }.foregroundColor(Color(.systemBlue))
            }

        }.padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar()
    }
}
