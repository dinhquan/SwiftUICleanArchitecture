//
//  SwiftRedux.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 11/4/21.
//

import Foundation
import Combine

typealias Reducer<State, Action> = (State, Action) -> State

typealias Middleware<State, Action> = (State, Action) -> AnyPublisher<Action, Never>

typealias Thunk<State, Action> = (_ dispatch: @escaping (Action) -> Void, _ getState: () -> State?) -> Void

class Store<State, Action>: ObservableObject {
    @Published private(set) var state: State

    private let reducer: Reducer<State, Action>
    private let middlewares: [Middleware<State, Action>]
    private let queue = DispatchQueue(label: "com.dinhquan.swiftredux", qos: .userInitiated)
    private var subscriptions: Set<AnyCancellable> = []

    init(
        initial: State,
        reducer: @escaping Reducer<State, Action>,
        middlewares: [Middleware<State, Action>] = []
    ) {
        self.state = initial
        self.reducer = reducer
        self.middlewares = middlewares
    }

    func dispatch(_ action: Action) {
        queue.sync {
            self.dispatch(self.state, action)
        }
    }

    func dispatch(_ thunk: Thunk<State, Action>) {
        let dispatch = { (action: Action) in
            let newState = self.reducer(self.state, action)
            self.state = newState
        }
        let getState = {
            return self.state
        }
        thunk(dispatch, getState)
    }

    private func dispatch(_ currentState: State, _ action: Action) {
        let newState = reducer(currentState, action)

        middlewares.forEach { middleware in
            let publisher = middleware(newState, action)
            publisher
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: dispatch)
                .store(in: &subscriptions)
            }

        state = newState
    }
}

func combineReducers<State, Action>(_ reducers: Reducer<State, Action>...) -> Reducer<State, Action> {
    return { state, action in
        var newState = state
        reducers.forEach { reducer in
            newState = reducer(state, action)
        }
        return newState
    }
}
