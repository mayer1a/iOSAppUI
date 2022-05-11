//
//  LoginWebKitViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 03.05.2022.
//

import UIKit
import WebKit


class LoginWebKitViewController: UIViewController {
    
    @IBOutlet weak var loginWebView: WKWebView?

    private var friends = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

        signIn()
    }


    // MARK: - authorization

    private func signIn() {

        self.loginWebView?.navigationDelegate = self

        var urlComponents = URLComponents(string: "https://oauth.vk.com/authorize")

        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: "8155664"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "scope", value: "327686"),
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
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        guard
            let url = navigationResponse.response.url,
            let fragment = url.fragment,
            url.path == "/blank.html",
            url.fragment?.contains("error") == nil
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
            let userId = Int(userIdString)
        else {
            return
        }

        Session.shared.token = token
        Session.shared.userID = userId

        print(token)
        print(userId)

        decisionHandler(.cancel)

        performSegue(withIdentifier: "PresentTabBarAfterLogin", sender: self)
    }

}
