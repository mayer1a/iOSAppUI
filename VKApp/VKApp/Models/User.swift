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

    static let friends = [User(id: 645353,
                               name: "Александр",
                               surname: "Кузнецов",
                               photos: ["AlexandrKuznetsov", "AlexandrKuznetsov"],
                               avatar: "AlexandrKuznetsov"),
                          User(id: 945764,
                               name: "Andy",
                               surname: "Hopkins",
                               photos: ["AndyHopkins", "AndyHopkins", "AndyHopkins"],
                               avatar: "AndyHopkins"),
                          User(id: 784374,
                               name: "Antonio",
                               surname: "Levitskiy"),
                          User(id: 526374,
                               name: "Ева",
                               surname: "Денисова",
                               photos: ["EvaDenisova", "EvaDenisova", "EvaDenisova", "EvaDenisova", "EvaDenisova"]),
                          User(id: 193847,
                               name: "John",
                               surname: "Smith",
                               avatar: "JohnSmith"),
                          User(id: 738473,
                               name: "Лев",
                               surname: "Фёдоров",
                               photos: ["LevFedorov", "photoSecond", "photoThird", "photoFourth", "photoWoman", "Mom"],
                               avatar: "LevFedorov"),
                          User(id: 938263,
                               name: "Лилия",
                               surname: "Зимина",
                               photos: ["LiliaZimina", "photoWomanSecond"],
                               avatar: "LiliaZimina"),
                          User(id: 125638,
                               name: "Miron",
                               surname: "Abduraid",
                               photos: ["MironAbduraid"],
                               avatar: "MironAbduraid"),
                          User(id: 354639,
                               name: "Ольга",
                               surname: "Винокурова",
                               photos: ["OlgaVinokyrova", "photoWomanThird"],
                               avatar: "OlgaVinokyrova")]
}
