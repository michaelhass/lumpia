//
//  Store.swift
//  Lumpia
//
//  Created by Michael Haß on 21.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import Foundation

/// Marker protocol for actions / events that occure
/// during application runtime
protocol Action { }

/// An action that may trigger another at some point.
protocol AsyncAction: Action {
    func execute(dispatch: @escaping DispatchFunction)
}

/// Only place where state updates should occure.
typealias Reducer<State> = (_ state: State, _ action: Action) -> State

/// Function to dispatch actions on
typealias DispatchFunction = (_ action: Action) -> Void

/// Place where your Application State is stored. Accepts actions and passes them to
/// the reducers.
/// NOTE: Middleware is not supported yet.
final class Store<State>: ObservableObject {

    @Published private(set) var state: State
    private let reducer: Reducer<State>

    /// Initializes a Store with the application's main state and reducer.
    ///
    /// - Parameters:
    ///   - initialState: The application's root state
    ///   - reducer: The root reducer to use
    init(initialState: State, reducer: @escaping Reducer<State>) {
        self.state = initialState
        self.reducer = reducer
    }

    /// Passes the given action to the correct reducer.
    /// Code will be executed on main thread because state updates directly
    /// trigger view updates -> @published.
    ///
    /// NOTE: in case of an AsyncAction, the execute(dispatch:) function will be called after
    /// the passed action was handled by the reducer.
    ///
    /// - Parameter action: Action to perform
    func dispatch(action: Action) {
        DispatchQueue.main.async {
            self.state = self.reducer(self.state, action)

            if let async = action as? AsyncAction {
                async.execute(dispatch: self.dispatch(action:))
            }
        }
    }
}
