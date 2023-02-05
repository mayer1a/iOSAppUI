//
//  SessionManager.swift
//  VKApp
//
//  Created by Artem Mayer on 03.05.2022.
//

import Foundation
import Alamofire

protocol NetworkServiceInterface: AnyObject {
    var getFriendsRequest: DataRequest? { get }

    func getFriends(_ completion: @escaping ([User]) -> Void)
    func getPhotosRequest(id: Int) -> DataRequest?
    func fetchNewsfeed(from specificTime: TimeInterval?, for nextFrom: String?, completion: @escaping ([News]) -> Void)
    func getPhotos(id: Int, _ completion: @escaping ([Photo]) -> Void)
}

// MARK: - SessionManager

final class NetworkService: NetworkServiceInterface {
    private let currentApiVersion = "5.131"
    private let friendFields = "first_name,photo_100,is_friend,blacklisted"
    
    // MARK: - getFriendsRequest
    private(set) lazy var getFriendsRequest: DataRequest? = {
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

    func getFriends(_ completion: @escaping ([User]) -> Void) {
        let baseUrl = "https://api.vk.com/method/friends.get"

        guard var urlComponents = URLComponents(string: baseUrl) else { return }

        urlComponents.queryItems = [
            URLQueryItem(name: "order", value: "hints"),
            URLQueryItem(name: "fields", value: friendFields),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: currentApiVersion)
        ]

        AF.request(urlComponents).response { response in
            guard let data = response.data else { return }

            do {
                let users = try JSONDecoder().decode(UserResponse.self, from: data).items
                completion(users)
            } catch {
                print(error)
            }
        }

    }
    
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

    // MARK: - getPhotos

    func getPhotos(id: Int, _ completion: @escaping ([Photo]) -> Void) {
        let baseUrl = "https://api.vk.com/method/photos.getAll"

        guard var urlComponents = URLComponents(string: baseUrl) else { return }

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
    
    // MARK: - getNewsfeed
    func fetchNewsfeed(from specificTime: TimeInterval? = nil,
                       for nextFrom: String? = nil,
                       completion: @escaping ([News]) -> Void)
    {
        let baseUrl = "https://api.vk.com/method/newsfeed.get"
        
        guard var urlComponents = URLComponents(string: baseUrl) else { return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "filters", value: "post,photo,wall_photo,video"),
            URLQueryItem(name: "return_banned", value: "0"),
            URLQueryItem(name: "max_photos", value: "1"),
            URLQueryItem(name: "count", value: "20"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: currentApiVersion)
        ]
        
        if let specificTime = specificTime {
            urlComponents.queryItems?.append(URLQueryItem(name: "start_time", value: "\(specificTime)"))
        }
        if let nextFrom = nextFrom {
            urlComponents.queryItems?.append(URLQueryItem(name: "start_from", value: "\(nextFrom)"))
        }
        
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

    private func pretty(from data: Data) {
        guard let object = try? JSONSerialization.jsonObject(with: data, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        else { return }

        print(prettyPrintedString)
    }
}
