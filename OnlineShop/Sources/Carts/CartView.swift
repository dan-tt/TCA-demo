//
//  File.swift
//  
//
//  Created by Dan Tran on 20/12/2023.
//

import Common
import ComposableArchitecture
import SwiftUI

@Reducer
public struct CartDomain {
    public init() {}
    
    public struct State: Equatable, Identifiable {
        public init(cart: Cart) {
            self.cart = cart
        }
        
        public var id: String {
            "\(cart.id)"
        }
        public let cart: Cart
    }
    
    public enum Action: Equatable {
        case delete(product: Product)
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .delete:
                return .none
            }
        }
    }
}

public struct CartView: View {
    let store: StoreOf<CartDomain>
    
    public init(store: StoreOf<CartDomain>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: \.cart) { viewStore in
            HStack {
                AsyncImage(
                    url: URL(string: viewStore.product.image)
                ) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 120, height: 120)
                VStack(alignment: .leading) {
                    Text(viewStore.product.title)
                        .lineLimit(1)
                        .font(.title2)
                    Text("$\(viewStore.product.price.description)")
                    Text("Quantity: \(viewStore.quantity)")
                }
                Spacer()
                Button(
                    action: {
                        viewStore.send(.delete(product: viewStore.product))
                    }
                ) {
                    Image(systemName: "trash")
                }
                .padding(20)
            }
        }
    }
}

#Preview {
    CartView(
        store: Store(
            initialState: CartDomain.State(cart: Cart.sample[0]),
            reducer: {
                CartDomain()
            }
        )
    )
}
