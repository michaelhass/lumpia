//
//  AppReducer.swift
//  Lumpia
//
//  Created by Michael Haß on 21.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import Foundation

/// The main reducer of the application
///
/// - Parameters:
///   - state: The root state of the application
///   - action: Action to evaluate
/// - Returns: Updated appState
func appReducer(state: AppState, action: Action) -> AppState {
    var state = state
    state.searchState = imageSearchReducer(state: state.searchState, action: action)
    return state
}
