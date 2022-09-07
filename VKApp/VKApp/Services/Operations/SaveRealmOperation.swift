//
//  SaveRealmOperation.swift
//  VKApp
//
//  Created by Artem Mayer on 07.09.22.
//

import UIKit

// MARK: - Operation
final class SaveRealmOperation<T: Decodable>: Operation {
    
    // MARK: - main
    override func main() {
        guard let asyncParseDataOperation = dependencies.first as? AsyncParseDataOperation<T>,
              let inputData = asyncParseDataOperation.outputData
        else { return }
        
        switch T.self {
        case is User.Type:
            guard let users = inputData as? [User] else { return }
            RealmUser.saveData(data: users)
        case is Group.Type:
            guard let groups = inputData as? [Group] else { return }
            RealmGroup.saveData(data: groups)
        case is Photo.Type:
            guard let photos = inputData as? [Photo], let ownerId = photos.first?.ownerId else { return }
            RealmPhoto.saveData(data: photos, for: ownerId)
        default: break
        }
    }
}
