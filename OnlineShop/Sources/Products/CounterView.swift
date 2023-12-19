//
//  File.swift
//  
//
//  Created by Dan Tran on 19/12/2023.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
public struct CounterDomain {
    public init() {}
    
    public struct State: Equatable {
        public var count: Int = 0
        public init() {}
    }
    
    public enum Action: Equatable {
        case increment
        case decrement
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .increment:
                state.count += 1
                return .none
            case .decrement:
                state.count -= 1
                return .none
            }
        }
    }
}

public struct CounterView: View {
    let store: StoreOf<CounterDomain>
    
    public init(store: StoreOf<CounterDomain>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    Button(
                        action: {
                            viewStore.send(.decrement)
                        }
                    ) {
                        Image(systemName: "minus.circle")
                    }
                    Text("\(viewStore.count)")
                        .lineLimit(1)
                        .font(.title3)
                    Button(
                        action: {
                            viewStore.send(.increment)
                        }
                    ) {
                        Image(systemName: "plus.circle")
                    }
                }
            }
        }
    }
}

#Preview {
    CounterView(
        store: Store(
            initialState: CounterDomain.State(), 
            reducer: {
                CounterDomain()
            }
        )
    )
}
