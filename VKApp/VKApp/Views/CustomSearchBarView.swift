//
//  CustomAnimatedSearchBar.swift
//  VKApp
//
//  Created by Artem Mayer on 13.04.2022.
//

import UIKit

final class CustomSearchBarView: UIView {

    @IBOutlet weak var searchTextField: UITextField?
    @IBOutlet weak var searchIconImageView: UIImageView?
    @IBOutlet weak var searchCloseButton: UIButton?
    @IBOutlet weak var closeButtonTrailingConstraint: NSLayoutConstraint?
    @IBOutlet weak var searchIconCenterXConstraint: NSLayoutConstraint?
    @IBOutlet weak var searchTextFieldLeadingAnchor: NSLayoutConstraint?
    @IBOutlet weak var searchTextFieldTrailingConstraint: NSLayoutConstraint?


    // MARK: - layoutSubviews
    
    override func layoutSubviews() {
        super.layoutSubviews()

        setupComponents()
    }


    // MARK: - loadView

    func loadView() -> CustomSearchBarView? {
        let nib = UINib(nibName: "CustomSearchBarView", bundle: Bundle.main)
        let view = nib.instantiate(withOwner: nil).first as? CustomSearchBarView

        return view
    }


    // MARK: - setupComponents

    private func setupComponents() {

        // Text field rounded
        searchTextField?.clipsToBounds = true
        searchTextField?.layer.cornerRadius = 10
        searchTextField?.layer.masksToBounds = true
        searchTextField?.layer.borderColor = searchTextField?.backgroundColor?.cgColor
        searchTextField?.layer.borderWidth = 1

    }

}


