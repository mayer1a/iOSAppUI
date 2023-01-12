//
//  UserPhotoMockModel.swift
//  VKApp
//
//  Created by Artem Mayer on 12.01.2023.
//

import Foundation

// MARK: - UserPhotoMockModel

struct UserPhotoMockModel: Identifiable {
    var id: URL?
}

// MARK: - UserPhotosMock

struct UserPhotosMock {
    static let shared = UserPhotosMock()

    private init() { }

    let photos: [UserPhotoMockModel] = [
        UserPhotoMockModel(
            id: URL(string: "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8MXw3NjA4Mjc3NHx8ZW58MHx8fHw%3D&w=1000&q=80")),
        UserPhotoMockModel(
            id: URL(string: "https://images.ctfassets.net/1wryd5vd9xez/4DxzhQY7WFsbtTkoYntq23/a4a04701649e92a929010a6a860b66bf/https___cdn-images-1.medium.com_max_2000_1_Y6l_FDhxOI1AhjL56dHh8g.jpeg")),
        UserPhotoMockModel(
            id: URL(string: "https://3dnews.ru/assets/external/illustrations/2012/05/15/629311/deusexhuman530_resize.jpg")),
        UserPhotoMockModel(
            id: URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/27/Square%2C_Inc_-_Square_Logo.jpg")),
        UserPhotoMockModel(
            id: URL(string: "https://creators-images.vice.com/content-images/contentimage/no-slug/d4d24f28d34addbcb66fb9e86c8276b2.jpg")),
        UserPhotoMockModel(
            id: URL(string: "https://www.ekhartyoga.com/media/images/articles/content/Square.jpg")),
        UserPhotoMockModel(
            id: URL(string: "https://i2-prod.mirror.co.uk/incoming/article27085590.ece/ALTERNATES/n615/0_The-International-Festival-quotTattoo-Collection-2016quot-in-Kiev.jpg"))
    ]
}
