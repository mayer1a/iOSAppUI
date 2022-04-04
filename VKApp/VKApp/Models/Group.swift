//
//  Group.swift
//  VKApp
//
//  Created by Artem Mayer on 29.03.2022.
//

import Foundation

struct Group {
    let id: Int
    var name: String
    var avatar: String? = "NonAvatar"
    var isSubscribed: Bool = false

    static var nonSubscribedGroups = [
        Group(id: 687352, name: "Парк Развлечений \"Андромед\"", avatar: "AmusementParkAndromedia"),
        Group(id: 736463, name: "\"Black Hawks\" Basketball Team", avatar: "BlackHawksBasketBallTeam"),
        Group(id: 736252, name: "Работа с глиной", avatar: "ClayCrafting"),
        Group(id: 983746, name: "Сделай сам или домашний уют ☺️", avatar: "DIYOrCozyHome"),
        Group(id: 123343, name: "Флористика для начинающих", avatar: "FloristyForBeginners"),
        Group(id: 229384, name: "Компьютерный клуб \"Geek\"", avatar: "GeekComputerClub"),
        Group(id: 993847, name: "Hand Made Stories", avatar: "HandMadeStories"),
        Group(id: 377627, name: "Фотографы Москвы", avatar: "MoscowPhotographers"),
        Group(id: 993846, name: "Художники нового света", avatar: "NewWorldArtists"),
        Group(id: 545463, name: "Сплавы по рекам", avatar: "RaftingOnRivers"),
        Group(id: 809283, name: "Кольца на заказ", avatar: "RingsToOrder"),
        Group(id: 330948, name: "Мысли души")]

    static var subscribedGroups: [Group] = []
}
