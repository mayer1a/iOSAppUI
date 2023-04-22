//
//  DetachableObject.swift
//  VKApp
//
//  Created by Artem Mayer on 31.01.2023.
//

import Realm
import RealmSwift

// MARK: - DetachableObject

protocol DetachableObject: AnyObject {
    func detached() -> Self
}

// MARK: - Extensions

extension Object: DetachableObject {

    // MARK: - Functions

    func detached() -> Self {
        let detached = type(of: self).init()

        for property in objectSchema.properties {
            guard
                let value = value(forKey: property.name)
            else {
                continue
            }

            if let detachable = value as? DetachableObject {
                detached.setValue(detachable.detached(), forKey: property.name)
            } else {
                detached.setValue(value, forKey: property.name)
            }
        }

        return detached
    }
}

extension List: DetachableObject {

    // MARK: - Functions

    func detached() -> List<Element> {
        let result = List<Element>()

        forEach {
            if let detachableObject = $0 as? DetachableObject,
                let element = detachableObject.detached() as? Element {
                result.append(element)
            } else {
                result.append($0)
            }
        }

        return result
    }
}

