//
//  Store.swift
//  Lumpia
//
//  Created by Michael Haß on 21.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import Foundation

protocol SearchObserver {
    func searchStarted()
    func searchEnded(searchText: String)
    func searchCanceled()
}

protocol Action { }

protocol AsyncAction: Action {
    func execute(dispatch: @escaping DispatchFunction)
}

typealias Reducer<State> = (_ state: State, _ action: Action) -> State

typealias DispatchFunction = (_ action: Action) -> Void

final class Store<State>: ObservableObject {

    @Published public var state: State
    private let reducer: Reducer<State>

    init(initialState: State, reducer: @escaping Reducer<State>) {
        self.state = initialState
        self.reducer = reducer
    }

    func dispatch(action: Action) {
        self.state = self.reducer(self.state, action)

        if let async = action as? AsyncAction {
            async.execute(dispatch: self.dispatch(action:))
        }
    }
}
