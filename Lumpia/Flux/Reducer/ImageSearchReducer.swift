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
    case let queryAction as ImageSearchActions.ExecuteQuery:
        newState.status = ImageSearchState.Status.fetching(queryAction.query)
        newState.query = queryAction.query

    case let resultAction as ImageSearchActions.SetSearchResult:
        newState.images = state.images + resultAction.page.response.results
        newState.currentPage = resultAction.page
        newState.status  = .success(resultAction.page)

    case let errorAction as ImageSearchActions.ShowError:
        newState.status  = .failure(errorAction.error)

    default:
        break
    }

    return newState
}
