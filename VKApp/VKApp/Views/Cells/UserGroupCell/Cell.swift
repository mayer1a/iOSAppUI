//
//  Cell.swift
//  VKApp
//
//  Created by Artem Mayer on 30.12.2022.
//

import SwiftUI

struct Cell: View {

    // MARK: - Properties

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
        .padding(.horizontal, 20.0)
    }
}

struct UserCell_Previews: PreviewProvider {
    static var previews: some View {
        Cell(model: UserMock.shared.viewModel)
    }
}

// MARK: - AvatarView

struct AvatarView: View {

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

// MARK: Mock (To see an example display. Will remove)

struct CellViewModel {
    let id: Int
    let fullName: String
    let avatar: URL?
}

struct UserMock {

    static let shared = UserMock()

    let viewModel: CellViewModel

    init() {
        viewModel = CellViewModel(id: user.id,
                                  fullName: "\(user.firstName) \(user.lastName)",
                                  avatar: URL(string: user.avatar))
    }

    private let user = User(id: 654234,
                            firstName: "Alex",
                            lastName: "Morning",
                            isClosed: false,
                            canAccessClosed: false,
                            avatar: "https://upload.wikimedia.org/wikipedia/commons/2/27/Square%2C_Inc_-_Square_Logo.jpg",
                            blacklisted: 0,
                            isFriend: 1)
}

struct GroupMock {

    static let shared = GroupMock()

    let viewModel: CellViewModel

    init() {
        viewModel = CellViewModel(id: group.id,
                                  fullName: "\(group.name)",
                                  avatar: URL(string: group.avatar))
    }

    private let group = Group(id: -657635,
                              name: "Photographers",
                              isMember: 1,
                              avatar: "https://dvyvvujm9h0uq.cloudfront.net/com/articles/1515135672-shutterstock_284581649.jpg",
                              isClosed: 0)
}
