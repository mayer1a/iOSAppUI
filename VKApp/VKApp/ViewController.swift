//
//  ViewController.swift
//  VKApp
//
//  Created by Artem Mayer on 10.03.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var uiScrollView: UIScrollView!
    @IBOutlet weak var loginButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))

        // Присваиваем его UIScrollVIew
        uiScrollView?.addGestureRecognizer(hideKeyboardGesture)

        passwordTF.isSecureTextEntry = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)

        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
    }

    @objc func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let keyboardSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size

        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)

        self.uiScrollView?.contentInset = contentInsets
        uiScrollView?.scrollIndicatorInsets = contentInsets

        var viewRectangle = self.view.frame

        viewRectangle.size.height -= keyboardSize.height + 40

        if !viewRectangle.contains(loginButton.frame.origin) {
            let rectangleWithIndent =  CGRect(x: loginButton.frame.origin.x, y: loginButton.frame.origin.y, width: loginButton.frame.width, height: loginButton.frame.height + 20)

            uiScrollView.scrollRectToVisible(rectangleWithIndent, animated: true)
        }
    }

    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        uiScrollView?.contentInset = contentInsets
    }

    @objc func hideKeyboard() {
        self.uiScrollView?.endEditing(true)
    }

    @IBAction func enableLoginButton(_ sender: Any) {
        if !(passwordTF.text?.isEmpty ?? true) {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
}

