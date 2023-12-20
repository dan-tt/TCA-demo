//
//  File.swift
//  
//
//  Created by Dan Tran on 20/12/2023.
//

import Common

public struct Cart: Equatable, Identifiable {
    public init(product: Product, quantity: Int) {
        self.product = product
        self.quantity = quantity
    }
    
    public var id: Int {
        product.id
    }
    public let product: Product
    public let quantity: Int
}

extension Cart {
    public static var sample: [Cart] {
        Product.sample
            .map {
                Cart(product: $0, quantity: 1)
            }
    }
}
