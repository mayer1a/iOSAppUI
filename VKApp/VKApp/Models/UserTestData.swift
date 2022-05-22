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
    var photos: [PhotoTestData]?
    var avatar: String? = "NonAvatar"

    static var friends = [UserTestData(id: 645353,
                               firstName: "Александр",
                               lastName: "Кузнецов",
                               photos: [PhotoTestData(name: "AlexandrKuznetsov"),
                                        PhotoTestData(name: "AlexandrKuznetsov")],
                               avatar: "AlexandrKuznetsov"),
                          UserTestData(id: 645353,
                               firstName: "Александр",
                               lastName: "Кузнецов",
                               photos: [PhotoTestData(name: "AlexandrKuznetsov"),
                                        PhotoTestData(name: "AlexandrKuznetsov")],
                               avatar: "AlexandrKuznetsov"),
                          UserTestData(id: 645353,
                               firstName: "Александр",
                               lastName: "Кузнецов",
                               photos: [PhotoTestData(name: "AlexandrKuznetsov"),
                                        PhotoTestData(name: "AlexandrKuznetsov")],
                               avatar: "AlexandrKuznetsov"),
                          UserTestData(id: 945764,
                               firstName: "Andy",
                               lastName: "Hopkins",
                               photos: [PhotoTestData(name:"AndyHopkins"),
                                        PhotoTestData(name:"AndyHopkins"),
                                        PhotoTestData(name:"AndyHopkins")],
                               avatar: "AndyHopkins"),
                          UserTestData(id: 784374,
                               firstName: "Antonio",
                               lastName: "Levitskiy"),
                          UserTestData(id: 526374,
                               firstName: "Ева",
                               lastName: "Денисова",
                               photos: [PhotoTestData(name:"EvaDenisova"),
                                        PhotoTestData(name:"EvaDenisova"),
                                        PhotoTestData(name:"EvaDenisova"),
                                        PhotoTestData(name:"EvaDenisova"),
                                        PhotoTestData(name:"EvaDenisova")]),
                          UserTestData(id: 193847,
                               firstName: "John",
                               lastName: "Smith",
                               avatar: "JohnSmith"),
                          UserTestData(id: 738473,
                               firstName: "Лев",
                               lastName: "Фёдоров",
                               photos: [PhotoTestData(name:"LevFedorov"),
                                        PhotoTestData(name:"photoSecond"),
                                        PhotoTestData(name:"photoThird"),
                                        PhotoTestData(name:"photoFourth"),
                                        PhotoTestData(name:"photoWoman"),
                                        PhotoTestData(name:"Mom")],
                               avatar: "LevFedorov"),
                          UserTestData(id: 938263,
                               firstName: "Лилия",
                               lastName: "Зимина",
                               photos: [PhotoTestData(name:"LiliaZimina"),
                                        PhotoTestData(name:"photoWomanSecond")],
                               avatar: "LiliaZimina"),
                          UserTestData(id: 125638,
                               firstName: "Miron",
                               lastName: "Abduraid",
                               photos: [PhotoTestData(name:"MironAbduraid")],
                               avatar: "MironAbduraid"),
                          UserTestData(id: 354639,
                               firstName: "Ольга",
                               lastName: "Винокурова",
                               photos: [PhotoTestData(name:"OlgaVinokyrova"),
                                        PhotoTestData(name:"photoWomanThird")],
                               avatar: "OlgaVinokyrova")]
}
