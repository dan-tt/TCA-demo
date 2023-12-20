//
//  ProductListTests.swift
//  
//
//  Created by Dan Tran on 18/12/2023.
//

import Common
import ComposableArchitecture
import XCTest
import Products

@MainActor
final class ProductListTests: XCTestCase {
    
    func test_init_state() async {
        let store = TestStore(initialState: ProductListDomain.State()) {
            ProductListDomain()
        }
        
        XCTAssertEqual(store.state.isLoading, false)
        XCTAssertEqual(store.state.products, [])
    }
    
    func test_loadProducts_failure() async {
        let store = TestStore(initialState: ProductListDomain.State()) {
            ProductListDomain()
        } withDependencies: {
            $0.productClient.fetchProducts = { throw ProductClientError.invalidURL }
        }
        
        // enable Non-exhaustive testing
        store.exhaustivity = .off
        
        let error = ProductClientError.invalidURL
        await store.send(.loadProducts)
        
        await store.receive(.productsResponse(.failure(error)))
    }
    
    func test_loadProducts_success() async {
        let store = TestStore(initialState: ProductListDomain.State()) {
            ProductListDomain()
        } withDependencies: {
            $0.context = .test
        }
        store.exhaustivity = .off
        
        let products = Product.sample
        
        await store.send(.loadProducts)
        
        await store.receive(.productsResponse(.success(products))) {
            $0.products = IdentifiedArrayOf(
                uniqueElements: products.map { ProductDomain.State(product: $0) }
            )
        }
    }

}
