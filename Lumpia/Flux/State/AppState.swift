//
//  AppState.swift
//  Lumpia
//
//  Created by Michael Haß on 21.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import Foundation

// The application's root state
struct AppState {
    var searchState: ImageSearchState

    static var initialState: AppState {
        return .init(searchState: .initalState)
    }
}
