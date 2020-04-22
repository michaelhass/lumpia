//
//  SearchBar.swift
//  Lumpia
//
//  Created by Michael Haß on 21.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import SwiftUI

// MARK: - SearchObserver

protocol SearchObserver {
    func searchStarted()
    func searchEnded(searchText: String)
    func searchCanceled()
}

// MARK: - SearchBar

struct SearchBar: View {

    // MARK: Bindings

    @State private var text = ""
    @State private var showCancel: Bool = false

    // MARK: Properties

    private var searchObserver: SearchObserver

    // MARK: Init

    init(searchObserver: SearchObserver) {
        self.searchObserver = searchObserver
    }

    // MARK: View Builder

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")

            TextField("search", text: $text, onEditingChanged: { editing in
                if editing {
                    self.searchObserver.searchStarted()
                }
                self.showCancel = editing

            }, onCommit: {
                self.searchObserver.searchEnded(searchText: self.text)

            }).foregroundColor(.primary)

            Button(action: {
                self.text = ""
            }, label: {
                Image(systemName: "xmark.circle.fill")
            }).opacity(self.text.isEmpty ? 0 : 1)

            if showCancel {
                Button("Cancel") {
                    UIApplication.shared.dismissKeyboard()
                    self.text = ""
                    self.showCancel = false
                    self.searchObserver.searchCanceled()

                }.foregroundColor(Color(.systemBlue))
            }

        }.padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
    }
}

// MARK: - Preview

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchObserver: GalleryView.ImageSearchTextObserver(dispatch: { _ in }))
    }
}
