//
//  ContentView.swift
//  Lumpia
//
//  Created by Michael Haß on 18.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import SwiftUI

struct GalleryView: View {

    // MARK: Binding

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var store: Store<AppState>
    @State private var data: [ImageData] = []
    @State private var attributes: Attributes = .init()

    // MARK: View properties

    private var numberOfColumns: Int {
        horizontalSizeClass == .compact ? 2 : 3
    }

    private var cellSpacing: CGFloat {
        horizontalSizeClass == .compact ? 6 : 9
    }

    private let cornerRadius: CGFloat = 6

    // MARK: Views

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
            self.attributes = .init(state: state.searchState)
        }
    }

    /// Creates a view with a title and a search bar
    func headerView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Unsplash").font(.largeTitle)
                .bold()
            SearchBar(searchObserver: ImageSearchTextObserver(dispatch: store.dispatch(action:)))
        }.padding()
    }

    /// Returns the current content for the curren SearchState
    func content() -> some View {
        return ZStack {
            if !data.isEmpty {
                collectionView()
            }

            message(text: attributes.message).opacity(attributes.showMessage ? 1 : 0)

            if attributes.hasNext {
                nextButton(disabled: attributes.disableNext)
            }
        }
    }

    /// Returns a view with displaying the given text
    func message(text: String) -> some View {
        VStack {
            Spacer(minLength: 80)
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(Color.white.opacity(0.75))
                    .cornerRadius(cornerRadius)
                    .frame(width: 300, height: 150)

                Text(text)
                    .multilineTextAlignment(.center)
                    .cornerRadius(cornerRadius)
                    .background(Color.clear)
                    .frame(width: 300, height: 150)
            }

            Spacer()
        }
    }

    /// Creates a button on the bottom of it's surrounding content.
    /// The button action will trigger a FetchNextPage action.
    ///
    /// - Parameter disabled: Used while ImageSearchState is .fetching
    /// - Returns: Button wrapped in a VStack
    func nextButton(disabled: Bool) -> some View {
        VStack {
            Spacer()
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(Color.white)
                    .cornerRadius(cornerRadius)
                    .frame(width: 120, height: 40)

                Button(action: {
                    guard let page = self.store.state.searchState.currentPage else { return }
                    let action = ImageSearchActions.FetchNextPage(currentPage: page)
                    self.store.dispatch(action: action)

                }, label: {
                    Text("Next")
                        .bold()
                        .foregroundColor(Color(.systemBlue))
                }).disabled(disabled)
            }
        }
    }

    /// Creates a collection with the ImageData '$data*' as it's binding property.
    func collectionView() -> some View {
        CollectionView(data: $data, columns: numberOfColumns,
                       spacing: cellSpacing) { imageData, width in

                        ImageCell(imageData: imageData, preferredWidth: width, action: {
                            print("Thats tapped!: \($0.description)")
                        })
        }.padding(.horizontal)
    }
}

// MARK: - Nested types

extension GalleryView {

    // Helper managing view states
    struct Attributes {
        let message: String
        let showMessage: Bool
        let hasNext: Bool
        let disableNext: Bool

        init() {
            message = ""
            showMessage = false
            hasNext = false
            disableNext = true
        }

        init(state: ImageSearchState) {
            switch state.status {
            case .idle:
                message = "Hello World, \nThis is an example app using Swift"
                showMessage = true
            case .failure:
                if case .exceededRateLimit? = state.error {
                    message = "Oh no, you exceeded your rate limit. Please try again later."
                } else {
                    message = "Something went wrong."
                }
                showMessage = true
            default:
                message = ""
                showMessage = false
            }

            hasNext = state.status == .success && state.currentPage?.links[.next] != nil
            disableNext = state.status == .fetching
        }
    }

    struct ImageSearchTextObserver: SearchObserver {
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
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        return GalleryView()
    }
}
