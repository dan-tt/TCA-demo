//
//  File.swift
//  
//
//  Created by Dan Tran on 18/12/2023.
//

import Foundation

public struct Product: Codable, Equatable, Identifiable {
    public let id: Int
    public let title: String
    public let price: Double
    public let description: String
    public let category: String
    public let image: String
}

extension Product {
    public static var sample: [Product] {
        [
            Product(
                id: 1,
                title: "title 1",
                price: 1.0,
                description: "description 1",
                category: "category 1",
                image: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg"
            ),
            Product(
                id: 2,
                title: "title 2",
                price: 2.0,
                description: "description 2",
                category: "category 2",
                image: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg"
            ),
            Product(
                id: 3,
                title: "title 3",
                price: 3.0,
                description: "description 3",
                category: "category 3",
                image: "https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg"
            ),
        ]
    }
}
