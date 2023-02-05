//
//  LoginScreenWebKit.swift
//  VKApp
//
//  Created by Artem Mayer on 28.01.2023.
//

import SwiftUI
import WebKit
import SwiftKeychainWrapper

// MARK: - UIViewRepresentable

struct LoginScreenWebKit: UIViewRepresentable {

    // MARK: - Binding properties

    @Binding var isAuthorized: Bool

    // MARK: - Private properties

    private let isInfinityTokenDebug = true

    private var isTokenValid: Bool {
        let currentTime = Int(Date().timeIntervalSince1970)

        guard
            KeychainWrapper.standard.string(forKey: .token) != nil,
            KeychainWrapper.standard.integer(forKey: .userId) != nil,
            let tokenReceiptTime = KeychainWrapper.standard.integer(forKey: .tokenReceiptTime),
            let tokenExpiresIn = KeychainWrapper.standard.integer(forKey: .tokenExpiresIn),
            (tokenExpiresIn == 0 || currentTime - tokenReceiptTime < tokenExpiresIn)
        else {
            return false
        }

        return true
    }

    // MARK: - Constructions

    init(isAuthorized: Binding<Bool>) {
        self._isAuthorized = isAuthorized
        checkAuthorization()
    }

    // MARK: - Functions

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let request = buildAuthRequest() {
            uiView.load(request)
        }
    }

    func makeCoordinator() -> WebViewNavigationDelegate {
        return WebViewNavigationDelegate(vkLoginWebView: self)
    }

    // MARK: - Private functions

    private func buildAuthRequest() -> URLRequest? {
        var urlComponents = URLComponents(string: "https://oauth.vk.com/authorize")
        var scope = 270366
        scope += 256

        if isInfinityTokenDebug { scope += 65536 }

        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: "8155664"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "scope", value: String(scope)),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.131")
        ]

        return urlComponents?.url.map { URLRequest(url: $0) }
    }

    private func checkAuthorization() {
        if isTokenValid {
            guard
                let token = KeychainWrapper.standard.string(forKey: .token),
                let userId = KeychainWrapper.standard.integer(forKey: .userId)
            else {
                return
            }

            Session.shared.token = token
            Session.shared.userID = userId

            isAuthorized = true
        }
    }
}

// MARK: - WKNavigationDelegate

final class WebViewNavigationDelegate: NSObject, WKNavigationDelegate {

    // MARK: - Properties

    let vkLoginWebView: LoginScreenWebKit

    // MARK: - Constructions

    init(vkLoginWebView: LoginScreenWebKit) {
        self.vkLoginWebView = vkLoginWebView
    }

    // MARK: - Functions

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void)
    {
        guard
            let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }

        let parameters = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                
                dict[key] = value

                return dict
            }

        guard
            let token = parameters["access_token"],
            let userIdString = parameters["user_id"],
            let expiresIn = parameters["expires_in"],
            let userId = Int(userIdString)
        else {
            decisionHandler(.allow)
            return
        }

        KeychainWrapper.standard[.token] = token
        KeychainWrapper.standard[.tokenReceiptTime] = Int(Date().timeIntervalSince1970)
        KeychainWrapper.standard[.tokenExpiresIn] = Int(expiresIn)
        KeychainWrapper.standard[.userId] = userId

        Session.shared.token = token
        Session.shared.userID = userId

        vkLoginWebView.isAuthorized = true

        decisionHandler(.cancel)
    }
}
