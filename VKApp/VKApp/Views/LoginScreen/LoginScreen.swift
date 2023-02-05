//
//  LoginScreen.swift
//  VKApp
//
//  Created by Artem Mayer on 28.12.2022.
//

import SwiftUI
import Combine

// MARK: - LoginScreen

struct LoginScreen: View {

    // MARK: - State properties

    @State private var shouldShowMainView: Bool = false

    // MARK: - Private properties

    private let publisher = NotificationCenter.default.publisher(for: NSNotification.Name("vkTokenSaved"))

    // MARK: - Properties

    var body: some View {
        NavigationView {
            HStack {
                LoginScreenWebKit()
                    .onReceive(publisher) { _ in
                        shouldShowMainView = true
                    }
                NavigationLink(isActive: $shouldShowMainView) {
                    FriendsScreen()
                        .navigationBarBackButtonHidden(true)
                } label: { }
            }
        }
    }
}

// MARK: - ContainerView

private struct ContainerView: View {

    // MARK: - State properties

    @State private var shouldShowLogo: Bool = true
    @Binding var isUserLoggedIn: Bool

    // MARK: - Private properties

    private let keyboardIsOnPublisher = KeyboardPublisher.shared.keyboardPublishers

    // MARK: - Properties

    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                if shouldShowLogo {
                    Spacer(minLength: 100)
                } else {
                    Spacer(minLength: 30)
                }

                LogoView()
                InputView(isUserLoggedIn: $isUserLoggedIn)
            }
            .onReceive(keyboardIsOnPublisher) { isKeyboardOn in
                withAnimation(Animation.easeInOut(duration: 0.3)) {
                    self.shouldShowLogo = !isKeyboardOn
                }
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }

    }
}

// MARK: - Extensions

extension UIApplication {

    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}

// MARK: - InputView

struct InputView: View {

    // MARK: - State properties

    @State private var login = ""
    @State private var password = ""
    @State private var showIncorrectLoginData = false
    @Binding var isUserLoggedIn: Bool

    // MARK: - Private properties

    private var loginInputView: some View {
        TextField("Email или телефон", text: $login)
            .padding([.top, .bottom], 5)
            .padding([.leading, .trailing], 15)
            .font(.title3)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .frame(minHeight: 50)
            .clipShape(Capsule())
            .tint(.blue)
            .background(RoundedRectangle(cornerRadius: 13)
                .fill(Color(.quaternaryLabel)))
            .foregroundColor(.black)
            .overlay(RoundedRectangle(cornerRadius: 13)
                .stroke(.gray, lineWidth: 1))
            .padding([.leading, .trailing], 20)
    }

    private var passwordInputView: some View {
        SecureField("Пароль", text: $password)
            .padding([.top, .bottom], 5)
            .padding([.leading, .trailing], 15)
            .font(.title3)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .frame(minHeight: 50)
            .clipShape(Capsule())
            .tint(.blue)
            .background(RoundedRectangle(cornerRadius: 13)
                .fill(Color(.quaternaryLabel)))
            .foregroundColor(.black)
            .overlay(RoundedRectangle(cornerRadius: 13)
                .stroke(.gray, lineWidth: 1))
            .padding([.leading, .trailing], 20)
    }

    private var loginButton: some View {
        HStack {
            Spacer(minLength: 20)

            Button {
                UIApplication.shared.endEditing()
                verifyInputData()
            } label: {
                Text("Войти")
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .foregroundColor(.white)
                    .background(buttonColor)
                    .cornerRadius(13)
                    .overlay(
                        RoundedRectangle(cornerRadius: 13)
                            .stroke(buttonColor))
                    .font(.title3)

            }

            Spacer(minLength: 20)
        }
    }

    private var forgotPassword: some View {
        HStack {
            Spacer(minLength: 20)

            Button {
                UIApplication.shared.endEditing()
                print("\(login) forgotten password")
            } label: {
                Text("Забыли пароль?")
                    .foregroundColor(.blue)
                    .font(.callout)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .buttonStyle(.plain)

            Spacer(minLength: 20)
        }
    }

    private var buttonColor: Color {
        return (login.isEmpty || password.count < 6) ? .gray : .blue
    }

    private var inputView: some View {
        VStack(spacing: 10) {
            loginInputView
            passwordInputView
        }
    }

    private var incorrectLoginDataView: some View {
        HStack {
            Spacer(minLength: 20)

            Text("Неверный логин или пароль")
                .foregroundColor(.red)
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer(minLength: 20)
        }
    }

    // MARK: - Properties

    var body: some View {

        if showIncorrectLoginData {
            incorrectLoginDataView
            Spacer(minLength: 15)
        }

        inputView

        Spacer(minLength: 15)

        forgotPassword

        Spacer(minLength: 15)

        loginButton.disabled(login.isEmpty || password.count < 6)
    }

    // MARK: - Private functions

    private func verifyInputData() {
        if login == "SwiftyTester" && password == "111111" {
            isUserLoggedIn = true
            showIncorrectLoginData = false
        } else {
            showIncorrectLoginData = true
        }

        password = ""
    }
}

// MARK: - LogoView

struct LogoView: View {

    var body: some View {
        VStack {
            Image("vk_auth_icon")
                .resizable()
                .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                .frame(width: 128)

            Spacer(minLength: 30)

            Text("Вход Вконтакте")
                .font(Font.title.weight(.bold))

            Spacer(minLength: 30)
        }
    }

}

// MARK: - PublishersKeyboard

typealias PublishersKeyboard = Publishers.RemoveDuplicates<
    Publishers.Merge<
        Publishers.Map<NotificationCenter.Publisher, Bool>,
        Publishers.Map<NotificationCenter.Publisher, Bool>
    >
>

// MARK: - KeyboardPublisher

struct KeyboardPublisher {

    // MARK: - Properties

    static let shared = KeyboardPublisher()

    let keyboardPublishers: PublishersKeyboard

    // MARK: - Constructions

    private init() {
        let changeNotificationName = UIResponder.keyboardWillShowNotification
        let hideNotificationName = UIResponder.keyboardWillHideNotification

        let changePublisher = NotificationCenter.default.publisher(for: changeNotificationName).map { _ in true }
        let hidePublisher = NotificationCenter.default.publisher(for: hideNotificationName).map { _ in false }

        keyboardPublishers = Publishers.Merge(changePublisher, hidePublisher).removeDuplicates()
    }

}
