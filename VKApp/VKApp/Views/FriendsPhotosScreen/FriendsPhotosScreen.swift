//
//  FriendsPhotosScreen.swift
//  VKApp
//
//  Created by Artem Mayer on 12.01.2023.
//

import SwiftUI

struct FriendsPhotosScreen: View {

    // MARK: - State private properties

    @State private var itemHeight: CGFloat = 72.0

    // MARK: - Private Properties

    private let column: [GridItem] = [
        GridItem(.adaptive(minimum: 72.0)),
        GridItem(.adaptive(minimum: 72.0)),
        GridItem(.adaptive(minimum: 72.0))
    ]

    private let photos: [UserPhotoMockModel]
    private let photosCount: Int

    // MARK: - Construction
    
    init(photosCount: Int) {
        self.photosCount = photosCount
        self.photos = Array(UserPhotosMock.shared.photos[0...self.photosCount])
    }

    // MARK: - Properties

    var body: some View {
        ScrollView {
            LazyVGrid(columns: column, spacing: 10.0) {
                ForEach(photos) { photo in
                    GeometryReader { geometry in
                        PreviewPhotoView(url: photo.id)
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
