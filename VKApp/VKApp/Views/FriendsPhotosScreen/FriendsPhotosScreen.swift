//
//  FriendsPhotosScreen.swift
//  VKApp
//
//  Created by Artem Mayer on 12.01.2023.
//

import SwiftUI

// MARK: - FriendsPhotosScreen

struct FriendsPhotosScreen: View {

    // MARK: - State properties

    @State private var itemHeight: CGFloat = 72.0

    // MARK: - Observed properties

    @ObservedObject private var viewModel: UserPhotoViewModel

    // MARK: - Private Properties

    private let column: [GridItem] = [
        GridItem(.adaptive(minimum: 72.0)),
        GridItem(.adaptive(minimum: 72.0)),
        GridItem(.adaptive(minimum: 72.0))
    ]
    
    private let userId: Int

    // MARK: - Construction
    
    init(by userId: Int, viewModel: UserPhotoViewModel) {
        self.userId = userId
        self.viewModel = viewModel
    }

    // MARK: - Properties

    var body: some View {
        ScrollView {
            LazyVGrid(columns: column, spacing: 10.0) {
                ForEach(viewModel.detachedPhotos, id: \.id) { photo in
                    GeometryReader { geometry in
                            PreviewPhotoView(url: URL(string: photo.originalSizeUrl ?? ""))
                                .preference(key: HeightPreferenceKey.self, value: geometry.size.width)
                    }
                    .clipped()
                    .frame(height: itemHeight)
                }
            }
            .onPreferenceChange(HeightPreferenceKey.self) {
                itemHeight = $0
            }
            .padding([.horizontal, .top], 10)
        }
        .navigationTitle("Фотографии")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: viewModel.fetchPhotos)
    }
}

// MARK: - PreviewPhotoView

struct PreviewPhotoView: View {

    // MARK: - Properties

    let url: URL?

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Image("NonAvatar")
                        .resizable()
                        .aspectRatio(contentMode: .fill)

                    ProgressView()
                        .frame(width: 72, height: 72)
                }
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)

            case .failure:
                Image("NonAvatar")
                    .resizable()
                    .aspectRatio(contentMode: .fill)

            @unknown default:
                EmptyView()
            }
        }
    }
}

// MARK: - Extension

private extension FriendsPhotosScreen {

    struct HeightPreferenceKey: PreferenceKey {
        static let defaultValue: CGFloat = 0

        static func reduce(
            value: inout CGFloat,
            nextValue: () -> CGFloat
        ) {
            value = max(value, nextValue())
        }
    }
}
