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

    // MARK: - Construction

    private init() {
        self.sessionHelper = SessionHelper()
    }

    var getFriendsRequest: DataRequest? {
        sessionHelper.getFriendsRequest
    }

    // MARK: - Functions

    func getFriends(_ completion: @escaping ([User]) -> Void) {
        sessionHelper.getFriends(completion)
    }

    func getPhotosRequest(id: Int) -> DataRequest? {
        sessionHelper.getPhotosRequest(id: id)
    }

    func fetchNewsfeed(from specificTime: TimeInterval? = nil, for nextFrom: String? = nil, completion: @escaping ([News]) -> Void) {
        sessionHelper.fetchNewsfeed(from: specificTime, for: nextFrom, completion: completion)
    }
}
