//
//  User.swift
//  VKApp
//
//  Created by Artem Mayer on 29.03.2022.
//

import Foundation

struct User {
    let id: Int
    var name: String
    var surname: String
    var photos: [String]?
    var avatar: String? = "NonAvatar"
    var friends: [Int]?
    var groups: [Group]?
}
