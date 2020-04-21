//
//  ContentView.swift
//  Lumpia
//
//  Created by Michael Haß on 18.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import SwiftUI

struct SearchObserverTest: SearchObserver {
    let dispatch: DispatchFunction

    init(dispatch: @escaping DispatchFunction) {
        self.dispatch = dispatch
    }

    func searchStarted() {
        // Empty
    }

    func searchEnded(searchText: String) {
        dispatch(ImageSearchActions.ExecuteQuery(query: searchText))
    }

    func searchCanceled() {
        // Empty
    }
}

struct GalleryView: View {

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var store: Store<AppState>
    @State private var data: [ImageData] = []

    private var numberOfColumns: Int {
        horizontalSizeClass == .compact ? 2 : 3
    }

    private var cellSpacing: CGFloat {
        horizontalSizeClass == .compact ? 6 : 9
    }

    var body: some View {
        NavigationView {
            VStack {
                headerView()
                content()
            }
            // navigationBarTitle has to be called,
            // else setHidden does not have any effect. -.-
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)

        }
        .navigationViewStyle(StackNavigationViewStyle())
        .gesture(DragGesture().onChanged({ _ in
            UIApplication.shared.dismissKeyboard()
        })).onReceive(store.$state) { state in
            self.data = state.searchState.images
        }
    }

    func headerView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Unsplash").font(.largeTitle)
                .bold()
            SearchBar(searchObserver: SearchObserverTest(dispatch: store.dispatch(action:)))
        }.padding()
    }

    func content() -> some View {
        let searchState = store.state.searchState
        let text: String
        var showMessage: Bool = true
        let showNext: Bool = searchState.status == .success && searchState.currentPage?.links[.next] != nil
        let disableNext = searchState.status == .fetching

        if searchState.status == .idle {
            text = "Hello World, \nThis is an example app using Swift"
        } else if searchState.status == .failure, let error = searchState.error {
            text = "An error occured \(error)"
        } else {
            text = ""
            showMessage = false
        }

        return ZStack {
            if !data.isEmpty {
                collectionView()
            }
            message(text: text).opacity(showMessage ? 1 : 0)

            if showNext {
                nextButton(disabled: disableNext)
            }
        }
    }

    func message(text: String) -> some View {
        VStack {
            Spacer(minLength: 80)
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(Color.white.opacity(0.75))
                    .cornerRadius(6)
                    .frame(width: 300, height: 100)

                Text(text)
                    .multilineTextAlignment(.center)
                    .cornerRadius(6)
                    .background(Color.clear)
            }

            Spacer()
        }
    }

    func nextButton(disabled: Bool) -> some View {
        VStack {
            Spacer()
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(Color.white)
                    .cornerRadius(6)
                    .frame(width: 120, height: 40)

                Button(action: {

                }, label: {
                    Text("Next")
                        .bold()
                        .foregroundColor(Color(.systemBlue))
                }).disabled(disabled)
            }

        }
    }

    func collectionView() -> some View {
        CollectionView(data: $data, columns: numberOfColumns,
                       spacing: cellSpacing) { imageData, width in
            ImageCell(imageData: imageData, preferredWidth: width)
        }.padding(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        return GalleryView()
    }
}
