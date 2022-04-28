//
//  Session.swift
//  VKApp
//
//  Created by Artem Mayer on 28.04.2022.
//

import Foundation


struct Session {
    var token: String?
    var userID: Int?

    private init() {}

    static var shared: Session = Session()

}
