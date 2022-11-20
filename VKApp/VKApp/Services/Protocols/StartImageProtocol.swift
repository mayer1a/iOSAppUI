//
//  StartImageProtocol.swift
//  VKApp
//
//  Created by Artem Mayer on 19.11.2022.
//

import UIKit

// MARK: - StartImageProtocol
protocol StartImageProtocol {
    func fetchStartImage(for item: Int, with bounds: CGRect, completion: @escaping (UIImage?) -> Void)
}
