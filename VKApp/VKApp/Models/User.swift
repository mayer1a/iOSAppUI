//
//  User.swift
//  VKApp
//
//  Created by Artem Mayer on 04.05.2022.
//

import Foundation


class User: Decodable {
    let id: Int
    var firstName: String
    var lastName: String
    var isClosed: Bool
    var canAccessClosed: Bool
    var avatar: String

    var blacklisted: Int?
    var isFriend: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case isClosed = "is_closed"
        case canAccessClosed = "can_access_closed"
        case avatar = "photo_100"
        case isFriend = "is_friend"
        case blacklisted
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.isClosed = try container.decode(Bool.self, forKey: .isClosed)
        self.canAccessClosed = try container.decode(Bool.self, forKey: .canAccessClosed)
        self.avatar = try container.decode(String.self, forKey: .avatar)
        self.isFriend = try? container.decode(Int.self, forKey: .isFriend)
        self.blacklisted = try? container.decode(Int.self, forKey: .blacklisted)
    }
}


class UserResponse: Decodable {
    var count: Int
    var items: [User]

    enum CodingKeys: String, CodingKey {
        case response
    }

    enum RequestKeys: String, CodingKey {
        case count
        case items
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseValue = try container.nestedContainer(keyedBy: RequestKeys.self, forKey: .response)
        
        self.count = try responseValue.decode(Int.self, forKey: .count)
        self.items = try responseValue.decode([User].self, forKey: .items)
    }
}
