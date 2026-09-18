//
//  ServiceLayer.swift
//  SwiftConcurrencyExample
//
//  Created by selegic mac 01 on 16/09/26.
//

import Foundation

protocol ServiceProtocol {
    func network(page: Int) async throws -> [ModelData]
}

class ServiceLayer: ServiceProtocol {
    func network(page: Int) async throws -> [ModelData] {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts?_page=\(page)&_limit=10") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            return try JSONDecoder().decode([ModelData].self, from: data)
        } else {
            throw URLError(.badServerResponse)
        }
    }
}
