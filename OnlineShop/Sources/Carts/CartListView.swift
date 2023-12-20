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
        public var totalPrice: Double = 0
        
        public init(carts: IdentifiedArrayOf<CartDomain.State> = []) {
            self.carts = carts
        }
    }
    
    public enum Action: Equatable {
        case cart(id: String, action: CartDomain.Action)
        case getTotalPrice
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .cart(let id, let action):
                switch action {
                case .delete:
                    state.carts.removeAll(where: { $0.id == id })
                    return .send(.getTotalPrice)
                }
            case .getTotalPrice:
                state.totalPrice = state.carts.reduce(0.0,  {
                    $0 + ($1.cart.product.price * Double($1.cart.quantity))
                })
                return .none
            }
        }
        .forEach(\.carts, action: /Action.cart(id:action:)) {
            CartDomain()
        }
    }
}

public struct CartListView: View {
    let store: StoreOf<CartListDomain>
    
    public init(store: StoreOf<CartListDomain>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                List {
                    ForEachStore(
                        self.store.scope(
                            state: \.carts,
                            action: CartListDomain.Action.cart(id:action:)
                        ),
                        content: CartView.init(store:)
                    )
                }
                .safeAreaInset(edge: .bottom) {
                    Text("Total price: \(viewStore.totalPrice.description)")
                }
                .onAppear {
                    viewStore.send(.getTotalPrice)
                }
                .navigationTitle("Cart")
            }
        }
    }
}

#Preview {
    CartListView(
        store: Store(
            initialState: CartListDomain.State(
                carts: IdentifiedArrayOf(
                    uniqueElements: Cart.sample.map {
                        CartDomain.State(cart: $0)
                    }
                )
            ), reducer: {
                CartListDomain()
            }
        )
    )
}
