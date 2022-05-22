//
//  SessionManager.swift
//  VKApp
//
//  Created by Artem Mayer on 03.05.2022.
//

import Foundation
import Alamofire


class SessionManager {

    private init() {}

    private let currentApiVersion = "5.131"

    static let shared = SessionManager()


    // MARK: - loadFriendsList
    
    func loadFriendsList(completion: @escaping ([User]) -> Void) {

        let baseUrl = "https://api.vk.com/method/friends.get"

        guard
            var urlComponents = URLComponents(string: baseUrl),
            Session.shared.token != ""
        else {
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "order", value: "hints"),
            URLQueryItem(name: "fields", value: "first_name,photo_100,is_friend,blacklisted"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: currentApiVersion)
        ]


        AF.request(urlComponents).response { response in

            guard let data = response.data else { return }

            do {
                let friends = try JSONDecoder().decode(UserResponse.self, from: data).items
                
                completion(friends)
            } catch {
                print(error)
            }
        }
        
    }


    // MARK: - loadUserPhotos

    func loadUserPhotos(id: Int, completion: @escaping ([Photo]) -> Void) {

        let baseUrl = "https://api.vk.com/method/photos.getAll"

        guard
            var urlComponents = URLComponents(string: baseUrl),
            Session.shared.token != ""
        else {
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "owner_id", value: "\(id)"),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "photo_sizes", value: "1"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: currentApiVersion)
        ]

        AF.request(urlComponents).response { response in
            guard let data = response.data else { return }

            do {
                let photos = try JSONDecoder().decode(PhotoResponse.self, from: data).items

                completion(photos)
            } catch {
                print(error)
            }
        }

    }


    // MARK: - loadMyGroups

    func loadMyGroups(completion: @escaping ([Group]) -> Void) {

        let baseUrl = "https://api.vk.com/method/groups.get"

        guard
            var urlComponents = URLComponents(string: baseUrl),
            Session.shared.token != ""
        else {
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "filter", value: "groups,publics"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: currentApiVersion)
        ]

        AF.request(urlComponents).response { response in
            guard let data = response.data else { return }

            do {
                let myGroups = try JSONDecoder().decode(GroupResponse.self, from: data).items
                completion(myGroups)
            } catch {
                print(error)
            }
        }

    }


    // MARK: - loadSearchedGroups

    func loadSearchedGroups(searchText: String, completion: @escaping ([Group]) -> Void) {

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
            URLQueryItem(name: "count", value: "100"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: currentApiVersion)
        ]

        AF.request(urlComponents).response { response in
            guard let data = response.data else { return }

            do {
                let searchedGroups = try JSONDecoder().decode(GroupResponse.self, from: data).items
                // .filter({ group in group.isMember != 1 })

                completion(searchedGroups)
            } catch {
                print(error)
            }
        }

    }
    
}
