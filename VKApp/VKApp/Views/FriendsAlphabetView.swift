//
//  FriendsAlphabetView.swift
//  VKApp
//
//  Created by Artem Mayer on 09.05.2022.
//

import UIKit

// MARK: - UIControl
final class FriendsAlphabetView: UIControl {
    @IBOutlet var alphabetView: UIView?
    @IBOutlet weak var alphabetStackView: UIStackView?
    
    var characters = [Character]() {
        didSet {
            setupStackView()
        }
    }

    var selectedIndex: Int?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

// MARK: - FriendsAlphabetView
extension FriendsAlphabetView {

    // MARK: - setupView
    private func setupView() {
        Bundle.main.loadNibNamed("FriendsAlphabetView", owner: self, options: nil)

        guard let alphabetView = alphabetView else { return }

        self.addSubview(alphabetView)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        alphabetView.frame = self.bounds
    }

    // MARK: - beginTracking
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        updateSelectedLabel(using: touch)
        return super.beginTracking(touch, with: event)
    }

    // MARK: - continueTracking
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        updateSelectedLabel(using: touch)
        return super.beginTracking(touch, with: event)
    }

    // MARK: - endTracking
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        guard
            let touch = touch,
            let stackview = alphabetStackView?.arrangedSubviews as? [UILabel],
            let selectedIndex = selectedIndex
        else { return }

        updateSelectedLabel(using: touch)

        stackview[selectedIndex].textColor = .systemBlue
        self.selectedIndex = nil

        super.endTracking(touch, with: event)
    }

    // MARK: - cancelTracking
    override func cancelTracking(with event: UIEvent?) {
        guard
            let stackview = alphabetStackView?.arrangedSubviews as? [UILabel],
            let selectedIndex = selectedIndex
        else { return }

        stackview[selectedIndex].textColor = .systemBlue

        super.cancelTracking(with: event)
    }

    // MARK: - setupStackView
    private func setupStackView() {
        alphabetStackView?.arrangedSubviews.forEach { $0.removeFromSuperview() }

        characters.forEach { character in
            let label = UILabel()

            label.textAlignment = .center
            label.text = String(character)
            label.textColor = .systemBlue
            label.font = label.font.withSize(12.0)

            alphabetStackView?.addArrangedSubview(label)
        }
    }

    // MARK: - updateSelectedLabel
    private func updateSelectedLabel(using touch: UITouch) {
        let views = alphabetStackView?.arrangedSubviews as? [UILabel]
        let location = touch.location(in: self)

        views?.enumerated().forEach { (index, label) in
            if label.frame.contains(location) {
                guard selectedIndex != index else { return }

                selectedIndex = index
                sendActions(for: .valueChanged)
                
                label.textColor = .systemRed
            } else {
                label.textColor = .systemBlue
            }
        }
    }
}
