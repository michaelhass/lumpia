//
//  ImageSearchActions.swift
//  Lumpia
//
//  Created by Michael Haß on 21.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import Foundation

struct ImageSearchActions {

    // Make it mutable to allow easier testability
    static var unsplashService: UnsplashService? = shared?.unsplash

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

    struct SetSearchResult: Action {
        let page: PagedResponse
    }

    struct ShowError: Action {
        let error: ServiceError
    }
}
