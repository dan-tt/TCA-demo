//
//  File.swift
//  
//
//  Created by Dan Tran on 18/12/2023.
//

import Common
import ComposableArchitecture
import Foundation
import SwiftUI
import Carts

@Reducer
public struct ProductListDomain {
    public init() {}
    
    public struct State: Equatable {
        public var isLoading: Bool = false
        public var products: IdentifiedArrayOf<ProductDomain.State> = []
        
        public var isShowCartList = false
        public var cartListState: CartListDomain.State?
//        public var cartListState = CartListDomain.State()
        
        public init() {}
    }
    
    public enum Action: Equatable {
        public static func == (lhs: ProductListDomain.Action, rhs: ProductListDomain.Action) -> Bool {
            switch (lhs, rhs) {
            case (.loadProducts, .loadProducts):
                return true
            case let (.productsResponse(lhsResult), .productsResponse(rhsResult)):
                switch (lhsResult, rhsResult) {
                    case let (.success(lhsProducts), .success(rhsProducts)):
                        return lhsProducts == rhsProducts
                    case (.failure, .failure):
                        return true
                    default:
                        return false
                }
            default:
                return false
            }
        }
        
        case loadProducts
        case productsResponse(Result<[Product], Error>)
        case product(id: String, action: ProductDomain.Action)
        
        case cartList(CartListDomain.Action)
        case goToCartList(isPresented: Bool)
        case reset(product: Product)
    }
    
//    public let productClient: ProductClient
    @Dependency(\.productClient) var productClient
    
    enum CancelID {
        case products
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadProducts:
                guard !state.isLoading else { return .none }
                
                state.isLoading = true
                return .run { send in
                    await send(.productsResponse(
                        Result { try await self.productClient.fetchProducts() }
                    ))
                }
                .cancellable(id: CancelID.products)
                
            case let .productsResponse(.success(products)):
                state.isLoading = false
                state.products = IdentifiedArrayOf(
                    uniqueElements: products.map { ProductDomain.State(product: $0) }
                )
                return .none
                
            case .productsResponse(.failure):
                state.isLoading = false
                return .none
            case .product:
                return .none
                
            // Cart list actions
            case .cartList(let action):
                switch action {
                case let .cart(_, action):
                    switch action {
                    case .delete(let product):
                        return .run {send in
                            await send(.reset(product: product))
                        }
                    }
                case .getTotalPrice:
                    return .none
                }
            case .goToCartList(isPresented: let isPresented):
                state.isShowCartList = isPresented
                guard isPresented else {
                    state.cartListState = nil
                    return .none
                }
                state.cartListState = CartListDomain.State(
                    carts: IdentifiedArrayOf(
                        uniqueElements: state.products
                            .compactMap { product in
                                guard product.counterState.count > 0 else { return nil }
                                return CartDomain.State(
                                    cart: Cart(
                                        product: product.product,
                                        quantity: product.counterState.count
                                    )
                                )
                            }
                    )
                )
                return .none
                
            case .reset(let product):
                state.products[id: "\(product.id)"]?.counterState.count = 0
                return .none
            }
        }
        .forEach(\.products, action: /ProductListDomain.Action.product(id: action:)) {
            ProductDomain()
        }
        .ifLet(\.cartListState, action: /ProductListDomain.Action.cartList) {
            CartListDomain()
        }
    }
}

public struct ProductListView: View {
    let store: StoreOf<ProductListDomain>
    
    public init(store: StoreOf<ProductListDomain>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                List {
                    ForEachStore(
                        self.store.scope(
                            state: \.products,
                            action: ProductListDomain.Action.product(id:action:)
                        )
                    ) {
                        ProductView(store: $0)
                    }
                }
                .task {
                    viewStore.send(.loadProducts)
                }
                .navigationTitle("Products")
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button {
//                            viewStore.send(.goToCartList(isPresented: true))
//                        } label: {
//                            Text("Go to Cart")
//                        }
//                    }
//                }
//                .sheet(
//                    isPresented: viewStore.binding(
//                        get: \.isShowCartList,
//                        send: ProductListDomain.Action.goToCartList(isPresented:)
//                    )
//                ) {
//                    IfLetStore(
//                        self.store.scope(
//                            state: \.cartListState,
//                            action: ProductListDomain.Action.cartList
//                        )
//                    ) {
//                        CartListView(store: $0)
//                    }
//                }
            }
        }
    }
}

#Preview {
    ProductListView(
        store: Store(
            initialState: ProductListDomain.State()
        ){
            ProductListDomain()
        }
//        } withDependencies: {
//            $0.context = .preview
//        }
    )
}
