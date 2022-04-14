//
//  CustomAnimatedSearchBar.swift
//  VKApp
//
//  Created by Artem Mayer on 13.04.2022.
//

import UIKit

class CustomSearchBarView: UIView {

    @IBOutlet weak var searchTextField: UITextField?
    @IBOutlet weak var searchIconImageView: UIImageView?
    @IBOutlet weak var searchCloseButton: UIButton?

    override func layoutSubviews() {
        super.layoutSubviews()

        setupComponents()
    }

    // MARK: - loadView

    func loadView() -> UIView? {
        let nib = UINib(nibName: "CustomSearchBarView", bundle: Bundle.main)

        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? CustomSearchBarView else { return nil }

        return view
    }


    private func setupComponents() {

        // Text field rounded
        searchTextField?.clipsToBounds = true
        searchTextField?.layer.cornerRadius = 15
        searchTextField?.layer.masksToBounds = true
        searchTextField?.layer.borderColor = searchTextField?.backgroundColor?.cgColor
        searchTextField?.layer.borderWidth = 1

        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Search icon set constraint
        //guard let searchIconImageView = searchIconImageView else { return }

        //searchIconImageView.leadingAnchor.constraint(equalTo: self.centerXAnchor,
        //                                           constant: -(searchIconImageView.frame.width / 2)).isActive = true

    }

}
