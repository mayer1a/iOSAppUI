//
//  ViewPresentable.swift
//  VKApp
//
//  Created by Artem Mayer on 16.11.2022.
//

import UIKit

// MARK: - ViewPresentable
protocol ViewPresentable {
    func photoCellViewRect(of itemIndex: Int) -> CGRect
    func photoCellViewRect() -> CGRect
}
