//
//  ViewModel.swift
//  SwiftConcurrencyExample
//
//  Created by selegic mac 01 on 16/09/26.
//

import Foundation
import Combine

@MainActor
class ViewModel: ObservableObject {
    private let service: ServiceProtocol
    init(service: ServiceProtocol) {
        self.service = service
    }
    
    @Published var dataList: [ModelData] = []
    @Published var isLoading: Bool = false
    @Published var errMesage: String = ""
    
    func fetchData(page: Int) async {
        guard isLoading == false else { return }
        isLoading = true
         
        defer {
            isLoading = false
        }
        
        do {
            let newdata = try await service.network(page: page)
            
            if page == 1 {
                dataList = newdata
            }else {
                dataList.append(contentsOf: newdata)
            }
        
        }catch {
            self.errMesage = error.localizedDescription
            print("DECODE/NETWORK ERROR: \(error)")
        }
    }
}
