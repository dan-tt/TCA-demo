//
//  TCADemoApp.swift
//  TCADemo
//
//  Created by Dan Tran on 18/12/2023.
//

import SwiftUI
import ComposableArchitecture
import Products

@main
struct TCADemoApp: App {
    var body: some Scene {
        WindowGroup {
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
