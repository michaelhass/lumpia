//
//  Store.swift
//  Lumpia
//
//  Created by Michael Haß on 21.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import Foundation

protocol Action { }

protocol AsyncAction: Action {
    func execute(dispatch: @escaping DispatchFunction)
}

typealias Reducer<State> = (_ state: State, _ action: Action) -> State

typealias DispatchFunction = (_ action: Action) -> Void

final class Store<State>: ObservableObject {

    @Published private(set) var state: State
    private let reducer: Reducer<State>

    init(initialState: State, reducer: @escaping Reducer<State>) {
        self.state = initialState
        self.reducer = reducer
        // TODO: Implement middleware.
    }

    func dispatch(action: Action) {
        DispatchQueue.main.async {
            self.state = self.reducer(self.state, action)

            if let async = action as? AsyncAction {
                async.execute(dispatch: self.dispatch(action:))
            }
        }
    }
}
