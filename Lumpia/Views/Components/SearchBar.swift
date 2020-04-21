//
//  SearchBar.swift
//  Lumpia
//
//  Created by Michael Haß on 21.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import SwiftUI

protocol SearchObserver {
    func searchStarted()
    func searchEnded(searchText: String)
    func searchCanceled()
}

struct SearchBar: View {

    @State private var searchText = ""
    @State private var showCancelButton: Bool = false

    private var searchObserver: SearchObserver

    init(searchObserver: SearchObserver) {
        self.searchObserver = searchObserver
    }

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")

            TextField("search", text: $searchText, onEditingChanged: { editing in
                if editing {
                    self.searchObserver.searchStarted()
                }
                self.showCancelButton = editing

            }, onCommit: {
                self.searchObserver.searchEnded(searchText: self.searchText)

            }).foregroundColor(.primary)

            Button(action: {
                self.searchText = ""
            }, label: {
                Image(systemName: "xmark.circle.fill")
            }).opacity(self.searchText.isEmpty ? 0 : 1)

            if showCancelButton {
                Button("Cancel") {
                    UIApplication.shared.dismissKeyboard()
                    self.searchText = ""
                    self.showCancelButton = false
                    self.searchObserver.searchCanceled()

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
        SearchBar(searchObserver: SearchObserverTest(dispatch: { _ in }))
    }
}
