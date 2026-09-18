//
//  SwiftConcurrencyExampleTests.swift
//  SwiftConcurrencyExampleTests
//
//  Created by selegic mac 01 on 16/09/26.
//

import Testing
@testable import SwiftConcurrencyExample
import Foundation

@MainActor
struct SwiftConcurrencyExampleTests {

    @Test func fetchData_page1_setsDataList() async throws {
        let mock = MockServiceLayer()
        mock.result = .success([ModelData(id: 1, userId: 1, title: "Test", body: "Body")])
        let viewModel = ViewModel(service: mock)

        await viewModel.fetchData(page: 1)

        #expect(viewModel.dataList.count == 1)
        #expect(viewModel.dataList.first?.title == "Test")
        #expect(viewModel.isLoading == false)
    }

    @Test func fetchData_page2_appendsToExistingList() async throws {
        let mock = MockServiceLayer()
        let viewModel = ViewModel(service: mock)

        mock.result = .success([ModelData(id: 1, title: "First")])
        await viewModel.fetchData(page: 1)

        mock.result = .success([ModelData(id: 2, title: "Second")])
        await viewModel.fetchData(page: 2)

        #expect(viewModel.dataList.count == 2)
        #expect(viewModel.dataList.last?.title == "Second")
    }

    @Test func fetchData_onFailure_setsErrorMessageAndKeepsListEmpty() async throws {
        let mock = MockServiceLayer()
        mock.result = .failure(URLError(.badServerResponse))
        let viewModel = ViewModel(service: mock)

        await viewModel.fetchData(page: 1)

        #expect(!viewModel.errMesage.isEmpty)
        #expect(viewModel.dataList.isEmpty)
    }
}
