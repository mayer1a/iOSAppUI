//
//  User.swift
//  VKApp
//
//  Created by Artem Mayer on 29.03.2022.
//

import Foundation

struct UserTestData {
    let id: Int
    var firstName: String
    var lastName: String
    var isClosed: Bool?
    var canAccessClosed: Bool?
    var avatar: String
    var blacklisted: Int?
    var isFriend: Int?

    static var users = [UserTestData(id: 645353,
                                       firstName: "Александр",
                                       lastName: "Кузнецов",
                                       isClosed: false,
                                       canAccessClosed: false,
                                       avatar: "first",
                                       blacklisted: 0,
                                       isFriend: 1),
                          UserTestData(id: 645323,
                                       firstName: "Александр",
                                       lastName: "Кузнецов",
                                       isClosed: false,
                                       canAccessClosed: false,
                                       avatar: "second",
                                       blacklisted: 0,
                                       isFriend: 1),
                          UserTestData(id: 645343,
                                       firstName: "Александр",
                                       lastName: "Кузнецов",
                                       isClosed: false,
                                       canAccessClosed: false,
                                       avatar: "third",
                                       blacklisted: 0,
                                       isFriend: 1),
                          UserTestData(id: 945764,
                                       firstName: "Andy",
                                       lastName: "Hopkins",
                                       isClosed: false,
                                       canAccessClosed: false,
                                       avatar: "fourth",
                                       blacklisted: 0,
                                       isFriend: 1),
                          UserTestData(id: 784374,
                                       firstName: "Antonio",
                                       lastName: "Levitskiy",
                                       isClosed: false,
                                       canAccessClosed: false,
                                       avatar: "fifth",
                                       blacklisted: 0,
                                       isFriend: 1),
                          UserTestData(id: 526374,
                                       firstName: "Ева",
                                       lastName: "Денисова",
                                       isClosed: false,
                                       canAccessClosed: false,
                                       avatar: "sixth",
                                       blacklisted: 0,
                                       isFriend: 1),
                          UserTestData(id: 193847,
                                       firstName: "John",
                                       lastName: "Smith",
                                       isClosed: false,
                                       canAccessClosed: false,
                                       avatar: "seventh",
                                       blacklisted: 0,
                                       isFriend: 1),
                          UserTestData(id: 738473,
                                       firstName: "Лев",
                                       lastName: "Фёдоров",
                                       isClosed: false,
                                       canAccessClosed: false,
                                       avatar: "eighth",
                                       blacklisted: 0,
                                       isFriend: 1),
                          UserTestData(id: 938263,
                                       firstName: "Лилия",
                                       lastName: "Зимина",
                                       isClosed: false,
                                       canAccessClosed: false,
                                       avatar: "ninth",
                                       blacklisted: 0,
                                       isFriend: 1),
                          UserTestData(id: 125638,
                                       firstName: "Miron",
                                       lastName: "Abduraid",
                                       isClosed: false,
                                       canAccessClosed: false,
                                       avatar: "tenth",
                                       blacklisted: 0,
                                       isFriend: 1),
                          UserTestData(id: 354639,
                                       firstName: "Ольга",
                                       lastName: "Винокурова",
                                       isClosed: false,
                                       canAccessClosed: false,
                                       avatar: "eleventh",
                                       blacklisted: 0,
                                       isFriend: 1)]
}
