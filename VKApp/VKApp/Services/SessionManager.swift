//
//  SessionManager.swift
//  VKApp
//
//  Created by Artem Mayer on 03.05.2022.
//

import Foundation
import Alamofire


class SessionManager {

    private let currentApiVersion = "5.131"


    // MARK: - loadFriendsList
    
    func loadFriendsList() {

        let baseUrl = "https://api.vk.com/method/friends.get"

        guard
            var urlComponents = URLComponents(string: baseUrl),
            Session.shared.token != ""
        else {
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "order", value: "hints"),
            URLQueryItem(name: "fields", value: "city"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: currentApiVersion)
        ]

        AF.request(urlComponents).response { response in

            guard let data = response.data else { return }

            let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)

            SessionManager.printDelimiter(for: "FRIENDS LIST")
            print(json)
        }
        
    }


    // MARK: - loadUserPhotos

    func loadUserPhotos(id: Int) {

        let baseUrl = "https://api.vk.com/method/photos.getAll"

        guard
            var urlComponents = URLComponents(string: baseUrl),
            Session.shared.token != ""
        else {
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "owner_id", value: "\(id)"),
            URLQueryItem(name: "album_id", value: "profile"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: currentApiVersion)
        ]

        AF.request(urlComponents).response { response in
            guard let data = response.data else { return }

            let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)

            SessionManager.printDelimiter(for: "USER PHOTOS")
            print(json)
        }

    }


    // MARK: - loadMyGroups

    func loadMyGroups() {

        let baseUrl = "https://api.vk.com/method/groups.get"

        guard
            var urlComponents = URLComponents(string: baseUrl),
            Session.shared.token != ""
        else {
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: currentApiVersion)
        ]

        AF.request(urlComponents).response { response in
            guard let data = response.data else { return }

            let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)

            SessionManager.printDelimiter(for: "MY GROUPS")
            print(json)
        }

    }


    // MARK: - loadSearchedGroups

    func loadSearchedGroups(searchText: String) {

        let baseUrl = "https://api.vk.com/method/groups.search"

        guard
            var urlComponents = URLComponents(string: baseUrl),
            Session.shared.token != ""
        else {
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: searchText),
            URLQueryItem(name: "sort", value: "0"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: currentApiVersion)
        ]

        AF.request(urlComponents).response { response in
            guard let data = response.data else { return }

            let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)

            SessionManager.printDelimiter(for: "SEARCHED GROUP")
            print(json)
        }

    }


    // MARK: - printDelimeter

    private static func printDelimiter(for methodName: String) {
        print("\n\n\t\t\t\(methodName)")
        print("----------------------------------------------------------------")
    }
}
