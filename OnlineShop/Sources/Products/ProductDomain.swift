//
//  File.swift
//  
//
//  Created by Dan Tran on 18/12/2023.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct ProductDomain {
    public init() {}
    
    public struct State: Equatable, Identifiable {
        public init(product: Product) {
            self.product = product
        }
        
        public var id: String {
            "\(product.id)"
        }
        public let product: Product
        public var counterState = CounterDomain.State()
    }
    
    public enum Action: Equatable {
        case addToCart(CounterDomain.Action)
    }
    
    public var body: some Reducer<State, Action> {
        Scope(state: \.counterState, action: /ProductDomain.Action.addToCart) {
            CounterDomain()
        }
        Reduce { state, action in
            switch action {
            case .addToCart(.increment):
                return .none
            case .addToCart(.decrement):
                state.counterState.count = max(0, state.counterState.count)
                return .none
            }
        }
    }
}


public struct ProductView: View {
    let store: Store<ProductDomain.State, ProductDomain.Action>
    
    public init(store: Store<ProductDomain.State, ProductDomain.Action>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
                AsyncImage(
                    url: URL(string: viewStore.product.image)
                ) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                } placeholder: {
                    ProgressView()
                        .frame(width: 120, height: 120)
                }
                VStack(alignment: .leading) {
                    Text(viewStore.product.title)
                        .font(.title2)
                        .lineLimit(1)
                    Text(viewStore.product.description)
                        .lineLimit(2)
                    Text("Price: $\(viewStore.product.price.description)")
                        .font(.title3)
                    AddToCartView(
                        store: self.store.scope(
                            state: \.counterState,
                            action: ProductDomain.Action.addToCart
                        )
                    )
                }
            }
        }
    }
}

#Preview {
    ProductView(
        store: Store(
            initialState: ProductDomain.State(product: Product.sample[0])
        ) {
            ProductDomain()
        }
    )
}
