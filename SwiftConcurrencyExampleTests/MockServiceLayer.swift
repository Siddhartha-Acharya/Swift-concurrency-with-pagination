//
//  MockServiceLayer.swift
//  SwiftConcurrencyExample
//
//  Created by selegic mac 01 on 18/09/26.
//

import Foundation
@testable import SwiftConcurrencyExample

class MockServiceLayer: ServiceProtocol {
    var result: Result<[ModelData], Error> = .success([])

    func network(page: Int) async throws -> [ModelData] {
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
}
