//
//  PhotoView.swift
//  VKApp
//
//  Created by Artem Mayer on 04.04.2022.
//

import UIKit

class PhotoView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = self.frame.width / 2
    }
}
