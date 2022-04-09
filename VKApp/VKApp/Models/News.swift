//
//  News.swift
//  VKApp
//
//  Created by Artem Mayer on 09.04.2022.
//

import Foundation

struct News {
    let user: User
    let postingDate: String
    var text: String?
    var photos: [Photo]?
    var numberOfViews: Int = 0
    var numberOfLikes: Int = 0
    var numbersOfComments: Int = 0
    var numbersOfShares: Int = 0

    static var list = [
        News(user: User(id: 645353,
                        name: "Александр",
                        surname: "Кузнецов",
                        photos: [Photo(name: "AlexandrKuznetsov"),
                                 Photo(name: "AlexandrKuznetsov")],
                        avatar: "AlexandrKuznetsov"),
             postingDate: "09.04.2022 20:38",
             text: "Some text ...",
             photos: [Photo(name: "ClayCrafting")]),
        News(user: User(id: 738473,
                        name: "Лев",
                        surname: "Фёдоров",
                        photos: [Photo(name:"LevFedorov"),
                                 Photo(name:"photoSecond"),
                                 Photo(name:"photoThird"),
                                 Photo(name:"photoFourth"),
                                 Photo(name:"photoWoman"),
                                 Photo(name:"Mom")],
                        avatar: "LevFedorov"),
             postingDate: "09.04.2022 21:47",
             text: "Some text ...",
             photos: [Photo(name: "DIYOrCozyHome")]),
        News(user: User(id: 938263,
                        name: "Лилия",
                        surname: "Зимина",
                        photos: [Photo(name:"LiliaZimina"),
                                 Photo(name:"photoWomanSecond")],
                        avatar: "LiliaZimina"),
             postingDate: "09.04.2022 22:01",
             text: "Some text ...",
             photos: [Photo(name: "GeekComputerClub")])]
    
}
