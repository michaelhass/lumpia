//
//  ImageSearchReducer.swift
//  Lumpia
//
//  Created by Michael Haß on 21.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import Foundation

func imageSearchReducer(state: ImageSearchState, action: Action) -> ImageSearchState {

    var newState = state
    switch action {
    // Only update State if query has changed
    case let queryAction as ImageSearchActions.ExecuteQuery where state.query != queryAction.query:
        // Reset search state for every new query
        newState = .initalState
        newState.status = .fetching
        newState.query = queryAction.query

    case is ImageSearchActions.FetchNextPage:
        newState.status = .fetching

    case let resultAction as ImageSearchActions.SetSearchResult:
        newState.images = state.images + resultAction.page.response.results
        newState.currentPage = resultAction.page
        newState.status  = .success

    case let errorAction as ImageSearchActions.ShowError:
        // Reset search state in case of an error
        newState = .initalState
        newState.status  = .failure
        newState.error = errorAction.error

    default:
        break
    }

    return newState
}
