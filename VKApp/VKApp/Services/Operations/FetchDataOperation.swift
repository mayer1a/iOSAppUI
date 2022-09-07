//
//  FetchFriendsOperation.swift
//  VKApp
//
//  Created by Artem Mayer on 07.09.22.
//

import UIKit
import Alamofire

// MARK: - AsyncFetchOperation
final class FetchDataOperation: AsyncFetchOperation {
    private var request: DataRequest?
    var data: Data?
    
    // MARK: - init
    init(request: DataRequest?) {
        self.request = request
    }
    
    // MARK: - cancel
    override func cancel() {
        request?.cancel()
        super.cancel()
    }
    
    // MARK: - main
    override func main() {
        request?.responseData(queue: DispatchQueue.global()) { [weak self] response in
            self?.data = response.data
            self?.state = .finished
        }
    }
}
