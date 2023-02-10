//
//  LinearGradient+Extensions.swift
//  VKApp
//
//  Created by Artem Mayer on 10.02.2023.
//

import SwiftUI

extension LinearGradient {
    static let selectionBorderLinearGradient = LinearGradient(
        gradient: Gradient.selectionBorderGradient,
        startPoint: .leading,
        endPoint: .trailing
    )
}
