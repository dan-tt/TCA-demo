//
//  File.swift
//  
//
//  Created by Dan Tran on 20/12/2023.
//

import ComposableArchitecture
import XCTest
import Carts

@MainActor
final class CartListTests: XCTestCase {
    // 1. Test initial state
    // 2. Test delete cart item
    // 3. Test delete all cart items
    
    // 1. Test initial state
    func test_initialState() async {
        let store = TestStore(
            initialState: CartListDomain.State()
        ) {
            CartListDomain()
        }
        
        XCTAssertEqual(store.state.carts, [])
    }
    
    // 2. Test delete cart item
    func test_delete_cartItem() async {
        let carts = IdentifiedArrayOf(
            uniqueElements: Cart.sample.map { CartDomain.State(cart: $0) }
        )
        let store = TestStore(
            initialState: CartListDomain.State(carts: carts)
        ) {
            CartListDomain()
        }
        
        let removeId = carts.ids[0]
        await store.send(
            .cart(
                id: removeId,
                action: .delete(product: Cart.sample[0].product)
            )
        ) {
            $0.carts = carts.filter { $0.id != removeId }
        }
    }
}
