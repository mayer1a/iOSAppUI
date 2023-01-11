//
//  UserMockModel.swift
//  VKApp
//
//  Created by Artem Mayer on 11.01.2023.
//

import Foundation

struct UserMockModel {
    static let shared = UserMockModel()

    let users: [User] = [
        User(id: 654234,
             firstName: "Alex",
             lastName: "Morning",
             isClosed: false,
             canAccessClosed: false,
             avatar: "https://upload.wikimedia.org/wikipedia/commons/2/27/Square%2C_Inc_-_Square_Logo.jpg",
             blacklisted: 0,
             isFriend: 1),
        User(id: 654235,
             firstName: "Felix",
             lastName: "Arnon",
             isClosed: false,
             canAccessClosed: false,
             avatar: "https://upload.wikimedia.org/wikipedia/commons/2/27/Square%2C_Inc_-_Square_Logo.jpg",
             blacklisted: 0,
             isFriend: 1),
        User(id: 654236,
             firstName: "Siri",
             lastName: "Microns",
             isClosed: false,
             canAccessClosed: false,
             avatar: "https://upload.wikimedia.org/wikipedia/commons/2/27/Square%2C_Inc_-_Square_Logo.jpg",
             blacklisted: 0,
             isFriend: 1),
        User(id: 654237,
             firstName: "Marta",
             lastName: "Lessly",
             isClosed: false,
             canAccessClosed: false,
             avatar: "https://upload.wikimedia.org/wikipedia/commons/2/27/Square%2C_Inc_-_Square_Logo.jpg",
             blacklisted: 0,
             isFriend: 1),
        User(id: 654238,
             firstName: "Gregory",
             lastName: "Swift",
             isClosed: false,
             canAccessClosed: false,
             avatar: "https://upload.wikimedia.org/wikipedia/commons/2/27/Square%2C_Inc_-_Square_Logo.jpg",
             blacklisted: 0,
             isFriend: 1),
        User(id: 654239,
             firstName: "Nadya",
             lastName: "Moonie",
             isClosed: false,
             canAccessClosed: false,
             avatar: "https://upload.wikimedia.org/wikipedia/commons/2/27/Square%2C_Inc_-_Square_Logo.jpg",
             blacklisted: 0,
             isFriend: 1),
        User(id: 654240,
             firstName: "Frank",
             lastName: "Aberfeld",
             isClosed: false,
             canAccessClosed: false,
             avatar: "https://upload.wikimedia.org/wikipedia/commons/2/27/Square%2C_Inc_-_Square_Logo.jpg",
             blacklisted: 0,
             isFriend: 1)
    ]
}
