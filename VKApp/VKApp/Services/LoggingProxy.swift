//
//  LoggingProxy.swift
//  VKApp
//
//  Created by Artem Mayer on 24.12.2022.
//

import Foundation
import Alamofire

final class LoggingProxy: SessionHelperInterface {

    // MARK: - Properties

    static let shared = LoggingProxy()

    // MARK: - Private properties

    private let sessionHelper: SessionHelperInterface
    private let logger: Logger

    // MARK: - Construction

    private init() {
        self.sessionHelper = SessionHelper()
        self.logger = Logger()
    }

    var getFriendsRequest: DataRequest? {
        let request = sessionHelper.getFriendsRequest
        logger.addLog("FRIENDS REQUEST")

        return request
    }

    // MARK: - Functions

    func getFriends(_ completion: @escaping ([User]) -> Void) {
        sessionHelper.getFriends { [weak self] friends in
            self?.logger.addLog("FRIENDS REQUEST")
            completion(friends)
        }
    }

    func getPhotosRequest(id: Int) -> DataRequest? {
        let photos = sessionHelper.getPhotosRequest(id: id)
        logger.addLog("PHOTOS REQUEST")
        return photos
    }

    func fetchNewsfeed(from specificTime: TimeInterval? = nil, for nextFrom: String? = nil, completion: @escaping ([News]) -> Void) {
        sessionHelper.fetchNewsfeed(from: specificTime, for: nextFrom) { [weak self] newsfeed in
            self?.logger.addLog("NEWSFEED REQUEST")
            completion(newsfeed)
        }
    }
}
