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
    var photos: [Photo]?
    var avatar: String? = "NonAvatar"

    static var friends = [User(id: 645353,
                               name: "Александр",
                               surname: "Кузнецов",
                               photos: [Photo(name: "AlexandrKuznetsov"),
                                        Photo(name: "AlexandrKuznetsov")],
                               avatar: "AlexandrKuznetsov"),
                          User(id: 645353,
                               name: "Александр",
                               surname: "Кузнецов",
                               photos: [Photo(name: "AlexandrKuznetsov"),
                                        Photo(name: "AlexandrKuznetsov")],
                               avatar: "AlexandrKuznetsov"),
                          User(id: 645353,
                               name: "Александр",
                               surname: "Кузнецов",
                               photos: [Photo(name: "AlexandrKuznetsov"),
                                        Photo(name: "AlexandrKuznetsov")],
                               avatar: "AlexandrKuznetsov"),
                          User(id: 945764,
                               name: "Andy",
                               surname: "Hopkins",
                               photos: [Photo(name:"AndyHopkins"),
                                        Photo(name:"AndyHopkins"),
                                        Photo(name:"AndyHopkins")],
                               avatar: "AndyHopkins"),
                          User(id: 784374,
                               name: "Antonio",
                               surname: "Levitskiy"),
                          User(id: 526374,
                               name: "Ева",
                               surname: "Денисова",
                               photos: [Photo(name:"EvaDenisova"),
                                        Photo(name:"EvaDenisova"),
                                        Photo(name:"EvaDenisova"),
                                        Photo(name:"EvaDenisova"),
                                        Photo(name:"EvaDenisova")]),
                          User(id: 193847,
                               name: "John",
                               surname: "Smith",
                               avatar: "JohnSmith"),
                          User(id: 738473,
                               name: "Лев",
                               surname: "Фёдоров",
                               photos: [Photo(name:"LevFedorov"),
                                        Photo(name:"photoSecond"),
                                        Photo(name:"photoThird"),
                                        Photo(name:"photoFourth"),
                                        Photo(name:"photoWoman"),
                                        Photo(name:"Mom")],
                               avatar: "LevFedorov"),
                          User(id: 938263,
                               name: "Лилия",
                               surname: "Зимина",
                               photos: [Photo(name:"LiliaZimina"),
                                        Photo(name:"photoWomanSecond")],
                               avatar: "LiliaZimina"),
                          User(id: 125638,
                               name: "Miron",
                               surname: "Abduraid",
                               photos: [Photo(name:"MironAbduraid")],
                               avatar: "MironAbduraid"),
                          User(id: 354639,
                               name: "Ольга",
                               surname: "Винокурова",
                               photos: [Photo(name:"OlgaVinokyrova"),
                                        Photo(name:"photoWomanThird")],
                               avatar: "OlgaVinokyrova")]
}
