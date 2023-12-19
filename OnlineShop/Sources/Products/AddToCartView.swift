//
//  File.swift
//  
//
//  Created by Dan Tran on 19/12/2023.
//

import ComposableArchitecture
import SwiftUI

public struct AddToCartView: View {
    let store: StoreOf<CounterDomain>
    
    public init(store: StoreOf<CounterDomain>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            if viewStore.count > 0 {
                CounterView(store: self.store)
            } else {
                Button(
                    action: {
                        viewStore.send(.increment)
                    }
                ) {
                    Text("Add to cart")
                        .padding(8)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
    }
}

#Preview {
    AddToCartView(
        store: Store(
            initialState: CounterDomain.State(),
            reducer: {
                CounterDomain()
            }
        )
    )
}
