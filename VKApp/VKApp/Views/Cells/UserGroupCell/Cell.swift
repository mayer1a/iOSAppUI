//
//  Cell.swift
//  VKApp
//
//  Created by Artem Mayer on 30.12.2022.
//

import SwiftUI

struct Cell: View {

    // MARK: - Private properties

    private var model: CellViewModel

    // MARK: - Construction

    init(model: CellViewModel) {
        self.model = model
    }

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center) {
            AvatarView(url: model.avatar)

            Spacer(minLength: 20)

            Text(model.fullName)
                .modifier(TitleLabel())

        }
        .padding(.horizontal, 0.0)
    }
}

// MARK: - AvatarView

struct AvatarView: View {

    // MARK: - Properties

    let url: URL?

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ZStack {
                    CircleImage {
                        Image("NonAvatar")
                    }

                    ProgressView()
                        .frame(width: 72, height: 72)
                }
            case .success(let image):
                CircleImage {
                    image
                }
            case .failure:
                CircleImage {
                    Image("NonAvatar")
                }
            @unknown default:
                EmptyView()
            }
        }
    }
}
