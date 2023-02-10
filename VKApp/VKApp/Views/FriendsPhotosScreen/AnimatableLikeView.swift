//
//  AnimatableLikeView.swift
//  VKApp
//
//  Created by Artem Mayer on 04.02.2023.
//

import SwiftUI

struct AnimatableLikeView: View {

    // MARK: - Binding properties

    @Binding var likesCount: Int
    @Binding var isLiked: Bool

    // MARK: - State properties

    @State var isEnabledTransitionAnimation = false

    // MARK: - Properties

    var body: some View {
        ZStack {
            HStack(spacing: 5) {
                Text("\(likesCount)")
                    .font(.system(size: 20.0, weight: .bold))
                    .foregroundColor(Color(.systemBackground))
                    .rotation3DEffect(.radians(isLiked ? CGFloat.pi * 2 : 0),
                                      axis: (x: 0, y: 0, z: 1))
                    .rotation3DEffect(.radians(isLiked ? CGFloat.pi * 2 : 0),
                                      axis: (x: 0, y: 1, z: 0))
                    .offset(y: isEnabledTransitionAnimation ? -17 : 0)
                    .padding([.leading, .bottom, .top], 5)

                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 20.0, height: 17.0)
                    .foregroundColor(isLiked ? .red : Color(.systemBackground))
                    .offset(x: isEnabledTransitionAnimation ? -20 : 0)
                    .padding([.trailing, .bottom, .top], 5)
            }
        }
        .frame(minWidth: 50, minHeight: 22, maxHeight: 30)
        .background(Color(.black).opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .onTapGesture {
            withAnimation(.easeInOut(duration: 1)) {
                isLiked.toggle()
                likesCount = isLiked ? likesCount + 1 : likesCount - 1
            }
            withAnimation(.easeInOut(duration: 0.5)) {
                isEnabledTransitionAnimation.toggle()
            }
            withAnimation(.easeInOut(duration: 0.5).delay(0.5)) {
                isEnabledTransitionAnimation.toggle()
            }
        }
    }
}

