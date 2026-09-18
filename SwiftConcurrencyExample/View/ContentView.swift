//
//  ContentView.swift
//  SwiftConcurrencyExample
//
//  Created by selegic mac 01 on 16/09/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: ViewModel
    
    init(service: ServiceProtocol = ServiceLayer()) {
        _viewModel = StateObject(wrappedValue: ViewModel(service: service))
    }
    @State private var page = 1

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading && viewModel.dataList.isEmpty {
                    ProgressView().accessibilityIdentifier("loadingIndicator")
                } else if viewModel.dataList.isEmpty {
                    Text("No data found") .accessibilityIdentifier("emptyStateText")
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(alignment: .leading, spacing: 10) {
                            ForEach(viewModel.dataList) { data in
                                VStack(alignment: .leading) {
                                    Text(data.title ?? "")
                                        .font(.headline)
                                        .accessibilityElement(children: .contain)
                                        .accessibilityIdentifier("postTitle_\(data.id ?? 0)")

                                    Text(data.body ?? "")
                                        .font(.subheadline)

                                    Divider()

                                    if viewModel.dataList.last?.id == data.id &&
                                        viewModel.isLoading {
                                        ProgressView()
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                                .accessibilityElement(children: .contain)
                                .accessibilityIdentifier("postCell_\(data.id ?? 0)")
                                .onAppear {
                                    if viewModel.dataList.last?.id == data.id &&
                                        !viewModel.isLoading {

                                        page += 1

                                        Task {
                                            await viewModel.fetchData(page: page)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .accessibilityIdentifier("postsScrollView")
                }
            }
            .task {
                await viewModel.fetchData(page: page)
            }
        }
    }
}
