//
//  LoginWebKitViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 03.05.2022.
//

import UIKit
import WebKit
import SwiftKeychainWrapper
import RealmSwift

// MARK: - UIViewController
final class LoginWebKitViewController: UIViewController {
    @IBOutlet weak var loginWebView: WKWebView?

    private let isInfinityTokenDebug = true
    private var isTokenValid: Bool {
        let currentTime = Int(Date().timeIntervalSince1970)

        guard
            KeychainWrapper.standard.string(forKey: .token) != nil,
            let tokenReceiptTime = KeychainWrapper.standard.integer(forKey: .tokenReceiptTime),
            let tokenExpiresIn = KeychainWrapper.standard.integer(forKey: .tokenExpiresIn),
            KeychainWrapper.standard.integer(forKey: .userId) != nil,
            (tokenExpiresIn == 0 || currentTime - tokenReceiptTime < tokenExpiresIn)
        else { return false }

        return true
    }

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuthorization()
    }

    // MARK: - checkAuthorization
    private func checkAuthorization() {
        if isTokenValid {
            guard
                let token = KeychainWrapper.standard.string(forKey: .token),
                let userId = KeychainWrapper.standard.integer(forKey: .userId)
            else { return }

            Session.shared.token = token
            Session.shared.userID = userId

            self.loadView()
        } else {
            signIn()
        }
    }

    // MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if isTokenValid {
            performSegue(withIdentifier: "PresentTabBarAfterLogin", sender: self)
        }
    }

    // MARK: - signIn
    private func signIn() {
        self.loginWebView?.navigationDelegate = self

        var urlComponents = URLComponents(string: "https://oauth.vk.com/authorize")
        var scope = 270342
        if isInfinityTokenDebug { scope += 65536 }
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: "8155664"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "scope", value: String(scope)),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.131")
        ]

        guard let url = urlComponents?.url else { return }

        let request = URLRequest(url: url)

        self.loginWebView?.load(request)
    }
}

// MARK: - WKNavigationDelegate
extension LoginWebKitViewController: WKNavigationDelegate {

    // MARK: - webviewDecidePolicyDecisionHandler
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void)
    {
        guard
            let url = navigationResponse.response.url,
            let fragment = url.fragment,
            url.path == "/blank.html",
            url.fragment?.contains("error") != true
        else {
            decisionHandler(.allow)
            return
        }

        let parameters = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce(Dictionary<String, String>()) { partialResult, parameter in
                var dictionary = partialResult
                let key = parameter[0]
                let value = parameter[1]

                dictionary[key] = value
                
                return dictionary
            }

        guard
            let token = parameters["access_token"],
            let userIdString = parameters["user_id"],
            let userId = Int(userIdString),
            let expiresIn = parameters["expires_in"]
        else { return }

        KeychainWrapper.standard[.token] = token
        KeychainWrapper.standard[.tokenReceiptTime] = Int(Date().timeIntervalSince1970)
        KeychainWrapper.standard[.tokenExpiresIn] = Int(expiresIn)
        KeychainWrapper.standard[.userId] = userId

        Session.shared.token = token
        Session.shared.userID = userId

        decisionHandler(.cancel)

        performSegue(withIdentifier: "PresentTabBarAfterLogin", sender: self)
    }

    // MARK: - logout
    private func logout() {
        try? Realm().write {
            try? Realm().deleteAll()
        }

        KeychainWrapper.standard.removeAllKeys()

        Session.shared.token = nil
        Session.shared.userID = nil

        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier ?? "")
        UserDefaults.standard.synchronize()

        loginWebView?.cleanAllCookies()
        loginWebView?.refreshCookies()
    }
}

// MARK: - WKWebView
extension WKWebView {

    // MARK: - cleanAllCookies
    func cleanAllCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore
                    .default()
                    .removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }

    // MARK: - refreshCookies
    func refreshCookies() {
        self.configuration.processPool = WKProcessPool()
    }
}
