//
//  SessionManager.swift
//  VKApp
//
//  Created by Artem Mayer on 03.05.2022.
//

import Foundation
import Alamofire

// MARK: - SessionManager
class SessionHelper {
    private init() {}
    
    private let currentApiVersion = "5.131"
    private let friendFields = "first_name,photo_100,is_friend,blacklisted"
    private lazy var startTime = {
        String(Date().timeIntervalSince1970 - 86400)
    }()
    
    static let shared = SessionHelper()
    
    // MARK: - getFriendsRequest
    lazy var getFriendsRequest: DataRequest? = {
        let baseUrl = "https://api.vk.com/method/friends.get"
        
        guard var urlComponents = URLComponents(string: baseUrl) else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "order", value: "hints"),
            URLQueryItem(name: "fields", value: friendFields),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: currentApiVersion)
        ]
        
        return AF.request(urlComponents)
    }()
    
    // MARK: - getPhotosRequest
    func getPhotosRequest(id: Int) -> DataRequest? {
        let baseUrl = "https://api.vk.com/method/photos.getAll"
        
        guard var urlComponents = URLComponents(string: baseUrl) else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "owner_id", value: "\(id)"),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "photo_sizes", value: "1"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: currentApiVersion)
        ]
        
        return AF.request(urlComponents)
    }
    
    // MARK: - getNewsfeed
    func fetchNewsfeed(completion: @escaping ([News]) -> Void) {
        let baseUrl = "https://api.vk.com/method/newsfeed.get"
        
        guard var urlComponents = URLComponents(string: baseUrl) else { return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "return_banned", value: "0"),
            URLQueryItem(name: "start_time", value: startTime),
            URLQueryItem(name: "max_photos", value: "1"),
            URLQueryItem(name: "count", value: "50"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: currentApiVersion)
        ]
        
        AF.request(urlComponents).response { response in
            guard let data = response.data else { return }
            
            do {
                let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                
                newsResponse.parseData(data: data) { news in
                    completion(news)
                }
            } catch {
                print(error)
            }
        }
    }
}
