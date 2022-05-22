//
//  Group.swift
//  VKApp
//
//  Created by Artem Mayer on 29.03.2022.
//

import Foundation

struct GroupTestData {
    let id: Int
    var name: String
    var avatar: String? = "NonAvatar"
    var isSubscribed: Bool = false

    static var nonSubscribedGroups = [
        GroupTestData(id: 736252, name: "Работа с глиной", avatar: "ClayCrafting"),
        GroupTestData(id: 983746, name: "Сделай сам или домашний уют", avatar: "DIYOrCozyHome"),
        GroupTestData(id: 123343, name: "Флористика для начинающих", avatar: "FloristyForBeginners"),
        GroupTestData(id: 229384, name: "Компьютерный клуб \"Geek\"", avatar: "GeekComputerClub"),
        GroupTestData(id: 993847, name: "Hand Made Stories", avatar: "HandMadeStories"),
        GroupTestData(id: 377627, name: "Фотографы Москвы", avatar: "MoscowPhotographers"),
        GroupTestData(id: 993846, name: "Художники нового света", avatar: "NewWorldArtists"),
        GroupTestData(id: 545463, name: "Сплавы по рекам", avatar: "RaftingOnRivers"),
        GroupTestData(id: 809283, name: "Кольца на заказ", avatar: "RingsToOrder"),
        GroupTestData(id: 330948, name: "Мысли души")]

    static var subscribedGroups = [
        GroupTestData(id: 687352, name: "Парк Развлечений \"Андромед\"", avatar: "AmusementParkAndromedia"),
        GroupTestData(id: 736463, name: "\"Black Hawks\" Basketball Team", avatar: "BlackHawksBasketBallTeam")]
}
