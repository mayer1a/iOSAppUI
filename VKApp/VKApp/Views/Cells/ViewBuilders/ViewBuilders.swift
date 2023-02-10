//
//  ViewBuilders.swift
//  VKApp
//
//  Created by Artem Mayer on 30.12.2022.
//

import SwiftUI

// MARK: - CircleImage

struct CircleImage: View {

    // MARK: - State properties

    @State var isScaled = false

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
            .scaleEffect(isScaled ? 0.75 : 1)
            .onTapGesture {
                let animation = Animation
                    .interpolatingSpring(mass: 1, stiffness: 50, damping: 5, initialVelocity: 10)

                withAnimation(animation) {
                    self.isScaled.toggle()
                }
                withAnimation(animation.delay(1.2)) {
                    self.isScaled.toggle()
                }
            }
    }
}

