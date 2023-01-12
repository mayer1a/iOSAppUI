//
//  ViewModifiers.swift
//  VKApp
//
//  Created by Artem Mayer on 29.12.2022.
//

import SwiftUI

// MARK: - CircleShadow

struct CircleShadow: ViewModifier {

    // MARK: - Private properties

    private let shadowColor: Color
    private let shadowRadius: CGFloat

    // MARK: - Constructions

    init(shadowColor: Color = Color(.systemGray3), shadowRadius: CGFloat = 4.0) {
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
    }

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .background(Circle()
                .fill(Color(.systemGray3).opacity(0.75))
                .shadow(color: shadowColor, radius: shadowRadius, x: 7, y: 4))
    }
}

// MARK: - TitleLabel

struct TitleLabel: ViewModifier {

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .lineLimit(2)
            .background(.clear)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
