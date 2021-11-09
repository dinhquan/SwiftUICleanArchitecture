//
//  SwiftRedux.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 11/4/21.
//

import Foundation
import Combine

protocol Middleware {}

struct EpicMiddleware<State, Action>: Middleware {
    let epics: [Epic<State, Action>]
    
    init(epics: [Epic<State, Action>]) {
        self.epics = epics
    }
}

struct ThunkMiddleware: Middleware {}

struct LoggerMiddleware<State, Action>: Middleware {
    
}

typealias Reducer<State, Action> = (State, Action) -> State

typealias Epic<State, Action> = (State, Action) -> AnyPublisher<Action, Never>

typealias Thunk<State, Action> = (_ dispatch: @escaping (Action) -> Void, _ getState: () -> State?) -> Void

class Store<State, Action>: ObservableObject {
    @Published private(set) var state: State

    private let reducer: Reducer<State, Action>
    private let middlewares: [Middleware]
    private let queue = DispatchQueue(label: "com.dinhquan.swiftredux", qos: .userInitiated)
    private var subscriptions: Set<AnyCancellable> = []
    private let hasThunk: Bool
    
    init(
        initial: State,
        reducer: @escaping Reducer<State, Action>,
        middlewares: [Middleware] = []
    ) {
        self.state = initial
        self.reducer = reducer
        self.middlewares = middlewares
        hasThunk = middlewares.contains(where: { $0 is ThunkMiddleware })
    }

    func dispatch(_ action: Action) {
        queue.sync {
            self.dispatch(self.state, action)
        }
    }

    func dispatch(_ thunk: Thunk<State, Action>) {
        guard hasThunk else { return }
        
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
            if let mid = middleware as? EpicMiddleware<State, Action> {
                mid.epics.forEach { epic in
                    let publisher = epic(newState, action)
                    publisher
                        .receive(on: DispatchQueue.main)
                        .sink(receiveValue: dispatch)
                        .store(in: &subscriptions)
                }
            }
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

func combineEpics<State, Action>(_ epics: Epic<State, Action>...) -> Epic<State, Action> {
    return { state, action in
        let publishers = epics.map { $0(state, action) }
        return Publishers.MergeMany(publishers).eraseToAnyPublisher()
    }
}
