//
//  Session.swift
//  VKApp
//
//  Created by Artem Mayer on 28.04.2022.
//

import Foundation


struct Session {

    private init() {
        self.token = String()
        self.userID = Int()
    }
    
    var token: String?
    var userID: Int?

    static var shared = Session()

}
