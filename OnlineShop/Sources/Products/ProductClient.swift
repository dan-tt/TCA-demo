//
//  File.swift
//  
//
//  Created by Dan Tran on 18/12/2023.
//

import Foundation
import ComposableArchitecture

public struct ProductClient {
    public var fetchProducts: () async throws -> [Product]
//    public func fetchProducts() async throws -> [Product] {
//        throw ProductClientError() //Product.sample
//    }
}

extension ProductClient: DependencyKey {
    public static let testValue = ProductClient(
        fetchProducts: { Product.sample }
    )
    
    public static let previewValue = ProductClient(
        fetchProducts: { Product.sample }
    )
    
    public static let liveValue = ProductClient(
        fetchProducts: {
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "https://fakestoreapi.com/products")!)
            let products = try JSONDecoder().decode([Product].self, from: data)
            return products
        }
    )
}


extension DependencyValues {
    public var productClient: ProductClient {
        get {
            self[ProductClient.self]
        }
        set {
            self[ProductClient.self] = newValue
        }
    }
}


public enum ProductClientError: Error, Equatable {
    case invalidURL
}
