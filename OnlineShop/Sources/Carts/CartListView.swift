//
//  File.swift
//  
//
//  Created by Dan Tran on 20/12/2023.
//

import ComposableArchitecture
import SwiftUI
import Common

@Reducer
public struct CartListDomain {
    public init() {}
    
    public struct State: Equatable {
        public var carts: IdentifiedArrayOf<CartDomain.State> = []
        public init(carts: IdentifiedArrayOf<CartDomain.State> = []) {
            self.carts = carts
        }
    }
    
    public enum Action: Equatable {
        case cart(id: String, action: CartDomain.Action)
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .cart(let id, let action):
                switch action {
                case .delete:
                    state.carts.removeAll(where: { $0.id == id })
                }
                return .none
            }
        }
        .forEach(\.carts, action: /Action.cart(id:action:)) {
            CartDomain()
        }
    }
}
