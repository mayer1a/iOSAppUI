//
//  FriendsPhotosScreen.swift
//  VKApp
//
//  Created by Artem Mayer on 12.01.2023.
//

import SwiftUI

// MARK: - FriendsPhotosScreen

struct FriendsPhotosScreen: View {

    @Namespace var namespace

    // MARK: - State properties

    @State private var itemHeight: CGFloat = 72.0
    @State private var currentSelection: Int? = nil

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
                let ids = viewModel.detachedPhotos.map { $0.id }

                ForEach(viewModel.detachedPhotos, id: \.id) { photo in
                    if let index = ids.firstIndex(of: photo.id) {
                        ItemView(itemHeight: $itemHeight,
                                 selectionIndex: $currentSelection,
                                 photo: photo,
                                 cellIndex: index)
                        .matchedGeometryEffect(id: index, in: namespace, isSource: true)
                    }
                }
            }
            .onPreferenceChange(HeightPreferenceKey.self) {
                itemHeight = $0
            }
            .overlay {
                if let currentSelection = currentSelection {
                    SelectionRectangleGeometryEffect(sizeSide: $itemHeight)
                        .matchedGeometryEffect(id: currentSelection, in: namespace, isSource: false)
                }
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

// MARK: - LikeView

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

struct ItemView: View {

    // MARK: - Binding properties

    @Binding var itemHeight: CGFloat
    @Binding var selectionIndex: Int?

    // MARK: - Private properties

    private let photo: Photo
    private let cellIndex: Int
    private let itemAtRow: Int = 3

    // MARK: - Constructions

    init(itemHeight: Binding<CGFloat>, selectionIndex: Binding<Int?>, photo: Photo, cellIndex: Int) {
        self._itemHeight = itemHeight
        self._selectionIndex = selectionIndex
        self.photo = photo
        self.cellIndex = cellIndex
    }

    // MARK: - Properties

    var body: some View {
        ZStack {
            getGeometryView(for: photo)

            LikeView(likesCount: photo.likesCounter ?? 0, isLiked: photo.isLiked ?? false)
        }
    }

    // MARK: - Private functions

    private func getGeometryView(for photo: Photo) -> some View {
        return GeometryReader { geometry in
            let photoURL = URL(string: photo.originalSizeUrl ?? "")
            PreviewPhotoView(url: photoURL)
                .preference(key: HeightPreferenceKey.self, value: geometry.size.width)
                .anchorPreference(key: SelectionPreferenceKey.self, value: .bounds) {
                    self.cellIndex == self.selectionIndex ? $0 : nil
                }
                .onTapGesture {
                    self.selectionIndex = cellIndex
                }
        }
        .clipped()
        .frame(height: itemHeight)
    }

}

// MARK: - SelectionRectange

struct SelectionRectangleGeometryEffect: View {

    // MARK: - State properties

    @Binding var sizeSide: CGFloat

    // MARK: - Constructions

    init(sizeSide: Binding<CGFloat>) {
        self._sizeSide = sizeSide
    }

    // MARK: - Properties

    var body: some View {
        GeometryReader { proxy in
                Rectangle()
                    .fill(.clear)
                    .border(LinearGradient.selectionBorderLinearGradient, width: 2)
                    .frame(width: sizeSide, height: sizeSide)
        }
    }
}

// MARK: - SelectionPreferenceKey

struct SelectionPreferenceKey: PreferenceKey {

    // MARK: - Properties

    static var defaultValue: Anchor<CGRect>? = nil

    // MARK: - Functions

    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = value ?? nextValue()
    }
}

// MARK: - HeightPreferenceKey

struct HeightPreferenceKey: PreferenceKey {

    // MARK: - Properties

    static let defaultValue: CGFloat = 0

    // MARK: - Functions

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
