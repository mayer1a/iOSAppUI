//
//  LikesProtocol.swift
//  VKApp
//
//  Created by Artem Mayer on 26.09.22.
//

import Foundation

// MARK: - NewsInteractionProtocol
protocol NewsInteractionProtocol {
    func newsLikeButtonDidTapped(_ isLiked: Bool?, by indexPath: IndexPath?)
}
