//
//  GroupMockModel.swift
//  VKApp
//
//  Created by Artem Mayer on 12.01.2023.
//

import Foundation

struct GroupMockModel {

    // MARK: - Properties

    static let shared = GroupMockModel()

    let groups: [Group] = [
        Group(id: 234343,
              name: "Moscow's Photographer",
              isMember: 1,
              avatar: "https://images.squarespace-cdn.com/content/v1/61505c55c04b0a138b337894/1645392354605-KP1A18JWX5FAWEV29EAS/image-asset.png",
              isClosed: 0),
        Group(id: 982364,
              name: "Swifty",
              isMember: 1,
              avatar: "https://ac.appcircle.io/wp-content/uploads/2022/06/wwdc22-swiftui-inside-uicollectionview-square.png",
              isClosed: 0),
        Group(id: 243546,
              name: "NSU",
              isMember: 1,
              avatar: "https://studyinrussia.ru/upload/iblock/5de/5de8db2d5b30062282ee6e831659ef11.jpg",
              isClosed: 0),
        Group(id: 777635,
              name: "Новости Новосибирск",
              isMember: 1,
              avatar: "http://narslovar.ru/wp-content/uploads/2020/04/5-Novosibirskiy-Gosudarstvennyiy-Akademicheskiy-Teatr-Operyi-i-Baleta.jpg",
              isClosed: 0)
    ]
}
