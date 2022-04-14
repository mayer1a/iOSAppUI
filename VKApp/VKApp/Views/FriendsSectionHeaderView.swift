//
//  FriendsSectionHeaderView.swift
//  VKApp
//
//  Created by Artem Mayer on 14.04.2022.
//

import UIKit

class FriendsSectionHeaderView: UITableViewHeaderFooterView {

    static let reuseIdentifier: String = String(describing: FriendsSectionHeaderView.self)

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.backgroundColor = UIColor.systemGray6.cgColor
        self.alpha = 0.5
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
