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

    // MARK: - Construction
    
    init(viewModel: UserPhotoViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Properties

    var body: some View {
        ScrollView {
            LazyVGrid(columns: column, spacing: 10.0) {
                ForEach(viewModel.detachedPhotos, id: \.id) { photo in
                    ZStack {
                        getGeometryView(for: photo)

                        LikeView(likesCount: photo.likesCounter ?? 0, isLiked: photo.isLiked ?? false)
                    }
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

    // MARK: - Private functions

    private func getGeometryView(for photo: Photo) -> some View {
        return GeometryReader { geometry in
            let photoURL = URL(string: photo.originalSizeUrl ?? "")
            PreviewPhotoView(url: photoURL)
                .preference(key: HeightPreferenceKey.self, value: geometry.size.width)
        }
        .clipped()
        .frame(height: itemHeight)
    }
}

// MARK: - PreviewPhotoView

struct PreviewPhotoView: View {

    // MARK: - State properties

    @State var isClosed = false

    // MARK: - Properties

    let url: URL?

    var body: some View {
        ZStack {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty, .failure:
                    Image("NonAvatar")
                        .resizable()
                        .aspectRatio(contentMode: .fill)

                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)

                @unknown default:
                    EmptyView()
                }
            }
            .onAppear {
                isClosed = true
            }
            
            if !isClosed {
                TimerProgressView(isClosed: $isClosed)
            }
        }

    }

}

struct LikeView: View {

    // MARK: - State propertires

    @State var likesCount: Int
    @State var isLiked: Bool

    // MARK: - Properties

    var body: some View {
        VStack {
            Spacer(minLength: 5)

            HStack {
                Spacer(minLength: 5)
                
                AnimatableLikeView(likesCount: $likesCount, isLiked: $isLiked)
                    .padding([.bottom, .trailing], 5)
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
