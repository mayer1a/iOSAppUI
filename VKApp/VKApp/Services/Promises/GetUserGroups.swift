//
//  GetUserGroups.swift
//  VKApp
//
//  Created by Artem Mayer on 10.09.22.
//

import Foundation
import PromiseKit

// MARK: - GetUserGroups
final class GetUserGroups {
    private let usersGroupsUrl: String
    private let searchedGroupsUrl: String
    private let currentApiVersion: String
    
    init() {
        self.usersGroupsUrl = "https://api.vk.com/method/groups.get"
        self.searchedGroupsUrl = "https://api.vk.com/method/groups.search"
        self.currentApiVersion = "5.131"
    }
    
    // MARK: - fetchUserGroups
    func fetchUserGroups() -> Promise<Data> {
        guard var urlComponents = URLComponents(string: usersGroupsUrl)
        else { return Promise(error: URLError.badURL as! Error) }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "filter", value: "groups,publics"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: currentApiVersion)
        ]
        
        guard let url = urlComponents.url else { return Promise(error: URLError.badURL as! Error) }
        
        return firstly {
            URLSession.shared.dataTask(.promise, with: url)
        }.map { data, _ in
            data
        }
    }
    
    // MARK: - fetchSearchedGroups
    func fetchSearchedGroups(by searchText: String) -> Promise<Data> {
        guard var urlComponents = URLComponents(string: searchedGroupsUrl)
        else { return Promise(error: URLError.badURL as! Error) }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: searchText),
            URLQueryItem(name: "sort", value: "0"),
            URLQueryItem(name: "count", value: "100"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: currentApiVersion)
        ]
        
        guard let url = urlComponents.url else { return Promise(error: URLError.badURL as! Error) }
        
        return firstly {
            URLSession.shared.dataTask(.promise, with: url)
        }.map { data, _ in
            data
        }
    }
    
    // MARK: - parseGroups
    func parseGroups(data: Data) -> Promise<[Group]> {
        return firstly {
            Promise<GroupResponse> { seal in
                guard let group = try? JSONDecoder().decode(GroupResponse.self, from: data)
                else {
                    seal.reject(URLError.badURL as! Error)
                    return
                }
                
                seal.fulfill(group)
            }.compactMap { groupResponse in
                groupResponse.items
            }
        }
    }
}
