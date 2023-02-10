//
//  Group.swift
//  VKApp
//
//  Created by Artem Mayer on 04.05.2022.
//

import Foundation
import PromiseKit

// MARK: - Group
final class Community: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isMember = "is_member"
        case avatar = "photo_100"
        case isClosed = "is_closed"
    }
    
    let id: Int
    var name: String
    var isMember: Int?
    var avatar: String
    var isClosed: Int
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.isMember = try? container.decode(Int.self, forKey: .isMember)
        self.avatar = try container.decode(String.self, forKey: .avatar)
        self.isClosed = try container.decode(Int.self, forKey: .isClosed)
        
        if isMember == nil {
            self.name += " (BANNED)"
        }
    }
    
    required init(
        id: Int,
        name: String,
        isMember: Int?,
        avatar: String,
        isClosed: Int
    ) {
        self.id = id
        self.name = name
        self.isMember = isMember
        self.avatar = avatar
        self.isClosed = isClosed
    }
}

// MARK: - GroupResponse
final class GroupResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case response
    }
    
    enum RequestKeys: String, CodingKey {
        case count
        case items
    }
    
    var count: Int
    var items: [Community]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseValue = try container.nestedContainer(keyedBy: RequestKeys.self, forKey: .response)
        
        self.count = try responseValue.decode(Int.self, forKey: .count)
        self.items = try responseValue.decode([Community].self, forKey: .items)
    }
}
