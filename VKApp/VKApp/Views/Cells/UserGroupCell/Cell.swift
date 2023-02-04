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

    // MARK: - State properties

    @State var isClosed = false

    // MARK: - Properties

    let url: URL?

    var body: some View {
        ZStack {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty, .failure:
                    CircleImage {
                        Image("NonAvatar")
                    }
                case .success(let image):
                    CircleImage {
                        image
                    }
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

// MARK: - ProgressView

struct TimerProgressView: View {

    // MARK: - State properties

    @Binding var isClosed: Bool

    // MARK: - Private properties

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // MARK: - Properties

    var body: some View {
        let startTime = Date().timeIntervalSince1970

        ProgressView()
            .frame(width: 72, height: 72)
            .onReceive(timer) { time in
                if time.timeIntervalSince1970 > startTime + 3 {
                    isClosed = true
                    timer.upstream.connect().cancel()
                }
            }
    }
}
