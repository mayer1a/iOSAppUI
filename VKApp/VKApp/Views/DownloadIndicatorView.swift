//
//  DownloadIndicatorView.swift
//  VKApp
//
//  Created by Artem Mayer on 11.04.2022.
//

import UIKit

// MARK: - UIView
final class DownloadIndicatorView: UIView {
    @IBOutlet weak var firstIndicatorDot: UIImageView?
    @IBOutlet weak var secondIndicatorDot: UIImageView?
    @IBOutlet weak var thirdIndicatorDot: UIImageView?
    
    // MARK: - loadView
    func loadView() -> UIView? {
        let nib = UINib(nibName: "DownloadIndicatorView", bundle: Bundle.main)
        let view = nib.instantiate(withOwner: nil, options: nil).first as? UIView
        
        view?.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
}
