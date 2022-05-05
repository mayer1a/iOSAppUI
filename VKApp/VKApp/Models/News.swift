//
//  News.swift
//  VKApp
//
//  Created by Artem Mayer on 09.04.2022.
//

import Foundation

struct News {
    let user: UserTestData
    let postingDate: String
    var text: String?
    var photos: [PhotoTestData]?
    var numberOfViews: Int = 0
    var numberOfLikes: Int = 0
    var numbersOfComments: Int = 0
    var numbersOfShares: Int = 0

    static var list = [
        News(user: UserTestData(id: 645353,
                        firstName: "Александр",
                        lastName: "Кузнецов",
                        photos: [PhotoTestData(name: "AlexandrKuznetsov"),
                                 PhotoTestData(name: "AlexandrKuznetsov")],
                        avatar: "AlexandrKuznetsov"),
             postingDate: "09.04.2022 20:38",
             text: "Some text ...",
             photos: [PhotoTestData(name: "ClayCrafting")]),
        News(user: UserTestData(id: 738473,
                        firstName: "Лев",
                        lastName: "Фёдоров",
                        photos: [PhotoTestData(name:"LevFedorov"),
                                 PhotoTestData(name:"photoSecond"),
                                 PhotoTestData(name:"photoThird"),
                                 PhotoTestData(name:"photoFourth"),
                                 PhotoTestData(name:"photoWoman"),
                                 PhotoTestData(name:"Mom")],
                        avatar: "LevFedorov"),
             postingDate: "09.04.2022 21:47",
             text: "Some text ...",
             photos: [PhotoTestData(name: "DIYOrCozyHome")]),
        News(user: UserTestData(id: 938263,
                        firstName: "Лилия",
                        lastName: "Зимина",
                        photos: [PhotoTestData(name:"LiliaZimina"),
                                 PhotoTestData(name:"photoWomanSecond")],
                        avatar: "LiliaZimina"),
             postingDate: "09.04.2022 22:01",
             text: "Some text ...",
             photos: [PhotoTestData(name: "GeekComputerClub")])]
    
}
