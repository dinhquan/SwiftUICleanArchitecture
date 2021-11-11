//
//  SwiftRedux.swift
//  SwiftUICleanArchitecture
//
//  Created by Quan on 11/4/21.
//

import Foundation
import Combine

typealias Reducer<State, Action, Environment> =
    (inout State, Action, Environment) -> AnyPublisher<Action, Never>?

final class Store<State, Action, Environment>: ObservableObject {
    @Published private(set) var state: State

    private let environment: Environment
    private let reducer: Reducer<State, Action, Environment>
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        initialState: State,
        reducer: @escaping Reducer<State, Action, Environment>,
        environment: Environment
    ) {
        self.state = initialState
        self.reducer = reducer
        self.environment = environment
    }

    func dispatch(_ action: Action) {
        guard let effect = reducer(&state, action, environment) else {
            return
        }
        effect
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: dispatch)
            .store(in: &cancellables)
    }
}

func combineReducers<State, Action, Environment>(_ reducers: Reducer<State, Action, Environment>...) -> Reducer<State, Action, Environment> {
    return { state, action, environment in
        let publishers = reducers.map { $0(&state, action, environment) }
            .compactMap { $0 }
        return Publishers.MergeMany(publishers).eraseToAnyPublisher()
    }
}
