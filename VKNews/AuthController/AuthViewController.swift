//
//  AuthViewController.swift
//  VKNews
//
//  Created by Rail on 25.10.2022.
//

import UIKit

class AuthViewController: UIViewController {
    
    //    Кнопка входа в веб сервис авторизации ВК
    @IBOutlet weak var signInButton: UIButton!
    //    Достаём AuthService
    var authService: AuthService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        Имеем доступ к SceneDelegate глобально
        authService = SceneDelegate.shared().authService
        view.backgroundColor = .red
        prepareSignInButton()
    }
    
    @IBAction func signInTouchButton(_ sender: UIButton) {
        //       Вызываем метод с проверкой доступности предыдущей сессии
        authService.wakeUpSession()
    }
    //    Настройка отображения кнопки
    private func prepareSignInButton() {
        signInButton.layer.borderWidth = 2
        signInButton.layer.borderColor = UIColor.blue.cgColor
        signInButton.layer.cornerRadius = 5
    }
}

