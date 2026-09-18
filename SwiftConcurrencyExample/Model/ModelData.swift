//
//  ModelData.swift
//  SwiftConcurrencyExample
//
//  Created by selegic mac 01 on 16/09/26.
//

import Foundation

struct ModelData: Codable, Identifiable, Equatable {
    var id: Int?
    var userId: Int?
    var title: String?
    var body: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case title
        case body
    }
    
    init(id: Int? = nil, userId: Int? = nil, title: String? = nil, body: String? = nil) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ////for id
        if let id = try? container.decodeIfPresent(String.self, forKey: .id) {
            self.id = Int(id)
        }
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        
        ////userId
        if let userId = try? container.decodeIfPresent(String.self, forKey: .userId) {
            self.userId = Int(userId)
        }
        self.userId = try container.decodeIfPresent(Int.self, forKey: .userId)
        
        ////for title
        if let title = try? container.decodeIfPresent(Int.self, forKey: .title) {
            self.title = String(title)
        }
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        
        ////for content
        if let body = try? container.decodeIfPresent(Int.self, forKey: .body) {
            self.body = String(body)
        }
        self.body = try container.decodeIfPresent(String.self, forKey: .body)
    }
}
