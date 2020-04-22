//
//  ImageSearchActions.swift
//  Lumpia
//
//  Created by Michael Haß on 21.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import Foundation

/// Collection of image search related actions
struct ImageSearchActions {

    // Make it mutable to allow easier testability
    static var unsplashService: UnsplashService? = shared?.unsplash

    /// Requests a search with the given query.
    /// If the request was successfull a SetSearchResult with the received respons
    /// will be executede, else ShowError will be executed.
    struct ExecuteQuery: AsyncAction {
        let query: String

        func execute(dispatch: @escaping DispatchFunction) {
            unsplashService?.request(.search(query), decode: PagedResponse.init, completion: { result in
                switch result {
                case .success(let page):
                    dispatch(SetSearchResult(page: page))

                case .failure(let error):
                    dispatch(ShowError(error: error))
                }
            })?.resume()
        }
    }

    /// Requests the next page for the given curent page.
    /// If the request was successfull a SetSearchResult with the received response.
    /// Else ShowError will be executed.
    struct FetchNextPage: AsyncAction {
        let currentPage: PagedResponse

        func execute(dispatch: @escaping DispatchFunction) {
            unsplashService?.request(.next(currentPage), decode: PagedResponse.init, completion: { result in
                switch result {
                case .success(let page):
                    dispatch(SetSearchResult(page: page))

                case .failure(let error):
                    dispatch(ShowError(error: error))
                }
            })?.resume()
        }
    }

    /// Appends received page data to the existing data
    struct SetSearchResult: Action {
        let page: PagedResponse
    }

    /// Will display the given error
    struct ShowError: Action {
        let error: ServiceError
    }
}
