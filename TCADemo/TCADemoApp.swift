//
//  TCADemoApp.swift
//  TCADemo
//
//  Created by Dan Tran on 18/12/2023.
//

import SwiftUI
import ComposableArchitecture
import Products
import Carts

@main
struct TCADemoApp: App {
    var body: some Scene {
        WindowGroup {
//            CartListView(
//                store: Store(
//                    initialState: CartListDomain.State(
//                        carts: IdentifiedArrayOf(
//                            uniqueElements: Cart.sample.map {
//                                CartDomain.State(cart: $0)
//                            }
//                        )
//                    ), reducer: {
//                        CartListDomain()
//                    }
//                )
//            )
            ProductListView(
                store: Store(
                    initialState: ProductListDomain.State(),
                    reducer: {
                        ProductListDomain()
                    }
                )
            )
        }
    }
}
