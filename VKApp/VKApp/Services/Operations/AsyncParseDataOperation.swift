//
//  AsyncParseDataOperation.swift
//  VKApp
//
//  Created by Artem Mayer on 07.09.22.
//

import UIKit

// MARK: - Operation
final class AsyncParseDataOperation<T: Decodable>: Operation {
    var outputData: [T]?
    
    // MARK: - main
    override func main() {
        guard let fetchDataOperation = dependencies.first as? FetchDataOperation,
              let data = fetchDataOperation.data
        else { return }
        
        do {
            switch T.self {
            case is User.Type:
                outputData = (try JSONDecoder().decode(UserResponse.self, from: data).items) as? [T]
            case is Community.Type:
                outputData = (try JSONDecoder().decode(GroupResponse.self, from: data).items) as? [T]
            case is Photo.Type:
                outputData = (try JSONDecoder().decode(PhotoResponse.self, from: data).items) as? [T]
            default: break
            }
        } catch {
            print(error)
        }
    }
}
