//
//  MainCoordinator.swift
//  VKApp
//
//  Created by Artem Mayer on 05.02.2023.
//

import UIKit
import SwiftUI
import Combine

final class MainCoordinator {

    // MARK: - Properties

    let navigationController: UINavigationController

    // MARK: - Private properties

    private let loginViewModel: LoginViewModel
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Constructions

    public init(navigationController: UINavigationController, loginViewModel: LoginViewModel) {
        self.navigationController = navigationController
        self.loginViewModel = loginViewModel
    }

    // MARK: - Functions

    func start() {
        let loginViewBinding = Binding<Bool>.init { [weak self] in
            guard let self = self else { return false }

            return self.loginViewModel.isAuthorized
        } set: { [weak self] newValue in
            guard let self = self else { return }

            self.loginViewModel.isAuthorized = newValue
        }
        
        let loginViewController = UIHostingController(rootView: LoginScreenWebKit(isAuthorized: loginViewBinding))
        self.navigationController.pushViewController(loginViewController, animated: false)

        loginViewModel
            .$isAuthorized
            .removeDuplicates()
            .subscribe(on: RunLoop.main)
            .sink { [weak self] isAuthorized in
                guard let self = self else { return }

                if isAuthorized {
                    let friendsViewController = self.createFriendsController()
                    self.navigationController.pushViewController(friendsViewController, animated: true)
                } else {
                    self.navigationController.popToViewController(loginViewController, animated: false)
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Private functions

    private func createFriendsController() -> UIViewController {
        return UIHostingController(rootView: FriendsScreen().navigationBarBackButtonHidden(true))
    }

}
