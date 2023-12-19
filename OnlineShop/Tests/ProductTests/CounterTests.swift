//
//  File.swift
//  
//
//  Created by Dan Tran on 19/12/2023.
//

import ComposableArchitecture
import XCTest
import Products

// testing CounterDomain
// test case:
// 1. initial state
// 2. increment
// 3. decrement
// 4. decrement then increment

@MainActor
final class CounterTests: XCTestCase {
    // 1. initial state
    func test_initialState() async {
        let store = TestStore(
            initialState: CounterDomain.State()
        ) {
            CounterDomain()
        }
        
        XCTAssertEqual(store.state.count, 0)
    }
    // 2. increment
    func test_increment() async {
        let store = TestStore(
            initialState: CounterDomain.State()
        ) {
            CounterDomain()
        }
        
        await store.send(.increment) {
            $0.count = 1
        }
        await store.send(.increment) {
            $0.count = 2
        }
    }
    // 3. decrement
    func test_decrement() async {
        let store = TestStore(
            initialState: CounterDomain.State()
        ) {
            CounterDomain()
        }
        
        await store.send(.decrement) {
            $0.count = -1
        }
        await store.send(.decrement) {
            $0.count = -2
        }
    }
    // 4. decrement then increment
    func test_decrement_then_increment() async {
        let store = TestStore(
            initialState: CounterDomain.State()
        ) {
            CounterDomain()
        }
        
        await store.send(.decrement) {
            $0.count = -1
        }
        await store.send(.increment) {
            $0.count = 0
        }
    }
}
