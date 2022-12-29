//
//  ViewBuilders.swift
//  VKApp
//
//  Created by Artem Mayer on 30.12.2022.
//

import SwiftUI

// MARK: - CircleImage

struct CircleImage: View {

    // MARK: - Private properties

    private var content: Image

    // MARK: - Constructions

    init(@ViewBuilder content: () -> Image) {
        self.content = content()
    }

    // MARK: - Body

    var body: some View {
        content
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 72, height: 72)
            .clipShape(Circle())
            .modifier(CircleShadow())
    }
}

