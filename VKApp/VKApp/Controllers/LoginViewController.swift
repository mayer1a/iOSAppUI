//
//  ViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 10.03.2022.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTF: UITextField?
    @IBOutlet weak var passwordTF: UITextField?
    @IBOutlet weak var uiScrollView: UIScrollView?
    @IBOutlet weak var loginButton: UIButton?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))

        // Присваиваем его UIScrollVIew
        uiScrollView?.addGestureRecognizer(hideKeyboardGesture)

        passwordTF?.isSecureTextEntry = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWasShown),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillBeHidden(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)

        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }

    @objc func keyboardWasShown(notification: Notification) {
        guard let loginButton = loginButton else { return }

        let info = notification.userInfo! as NSDictionary
        let keyboardSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue)

        guard let keyboardSize = keyboardSize?.cgRectValue.size else {
            return
        }

        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)

        self.uiScrollView?.contentInset = contentInsets
        uiScrollView?.scrollIndicatorInsets = contentInsets

        var viewRectangle = self.view.frame

        viewRectangle.size.height -= keyboardSize.height + 40

        if !viewRectangle.contains(loginButton.frame.origin) {
            let rectangleWithIndent =  CGRect(x: loginButton.frame.origin.x,
                                              y: loginButton.frame.origin.y,
                                              width: loginButton.frame.width,
                                              height: loginButton.frame.height + 20)

            uiScrollView?.scrollRectToVisible(rectangleWithIndent, animated: true)
        }
    }

    @objc func keyboardWillBeHidden(notification: Notification) {

        // Устанавливаем отступ внизу UIScrollView, равный 0
        uiScrollView?.contentInset = UIEdgeInsets.zero
    }

    @objc func hideKeyboard() {
        self.uiScrollView?.endEditing(true)
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if !isCorrectUserData() {
            showError()
        }

        return isCorrectUserData()
    }

    func isCorrectUserData() -> Bool {

        if loginTF?.text == "1" && passwordTF?.text == "1" {
            return true
        }

        return false
    }
    
    func showError() {
        let alter = UIAlertController(title: "Ошибка",
                                      message: "Введены не верные данные пользователя",
                                      preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)

        alter.addAction(action)

        present(alter, animated: true, completion: nil)
    }

    @IBAction func enableLoginButton(_ sender: Any) {
        guard let password = passwordTF?.text else { return }

        if password.isEmpty {
            loginButton?.isEnabled = false
        } else {
            loginButton?.isEnabled = true
        }
    }
}

