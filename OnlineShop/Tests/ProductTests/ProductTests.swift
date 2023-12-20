//
//  File.swift
//  
//
//  Created by Dan Tran on 20/12/2023.
//

import Common
import ComposableArchitecture
import XCTest
import Products

@MainActor
final class ProductTests: XCTestCase {
    // 1. Test initial state
    // 2. Test add to cart
    // 3. Test counter increment
    // 4. Test counter decrement
    
    // 1. Test initial state
    func test_initialState() async {
        let product = Product.sample[0]
        let store = TestStore(
            initialState: ProductDomain.State(product: product)
        ) {
            ProductDomain()
        }
        
        XCTAssertEqual(store.state.counterState, CounterDomain.State())
    }
    // 2. Test add to cart
    func test_addToCart() async {
        let product = Product.sample[0]
        let store = TestStore(
            initialState: ProductDomain.State(product: product)
        ) {
            ProductDomain()
        }
        
        await store.send(.addToCart(.increment)) {
            $0.counterState = CounterDomain.State(count: 1)
        }
    }
    
    // 3. Test counter increment
    func test_counter_increment() async {
        let product = Product.sample[0]
        let store = TestStore(
            initialState: ProductDomain.State(product: product)
        ) {
            ProductDomain()
        }
        
        await store.send(.addToCart(.increment)) {
            $0.counterState = CounterDomain.State(count: 1)
        }
        await store.send(.addToCart(.increment)) {
            $0.counterState = CounterDomain.State(count: 2)
        }
    }
    
    // 4.Test counter decrement
    func test_counter_decrement() async {
        let product = Product.sample[0]
        let store = TestStore(
            initialState: ProductDomain.State(product: product)
        ) {
            ProductDomain()
        }
        
        await store.send(.addToCart(.decrement))
        await store.send(.addToCart(.decrement))
    }
    
    // 5. Test counter decrement then increment
    func test_counter_increment_then_decrement() async {
        let product = Product.sample[0]
        let store = TestStore(
            initialState: ProductDomain.State(product: product)
        ) {
            ProductDomain()
        }
        
        await store.send(.addToCart(.increment)) {
            $0.counterState = CounterDomain.State(count: 1)
        }
        await store.send(.addToCart(.decrement)) {
            $0.counterState = CounterDomain.State(count: 0)
        }
    }
}
