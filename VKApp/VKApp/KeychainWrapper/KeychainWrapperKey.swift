//
//  KeychainWrapper.swift
//  VKApp
//
//  Created by Artem Mayer on 16.05.2022.
//

import SwiftKeychainWrapper

extension KeychainWrapper.Key {
    static let token: KeychainWrapper.Key = "token"
    static let tokenReceiptTime: KeychainWrapper.Key = "tokenReceiptTime"
    static let tokenExpiresIn: KeychainWrapper.Key = "tokenExpiresIn"
    static let userId: KeychainWrapper.Key = "userId"
}
