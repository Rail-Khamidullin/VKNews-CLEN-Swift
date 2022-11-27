//
//  AuthService.swift
//  VKNews
//
//  Created by Rail on 31.10.2022.
//  Copyright © 2022 Хамидуллин Раиль. All rights reserved.
//

import Foundation
import VKSdkFramework

//   class используется чтобы в будущем избежать утечек памяти и мы можем подписывать только под классы
protocol AuthServiceDelegate: class {
    func authServiceShouldShow(_ viewController: UIViewController)
    func authServiceSingIn()
    func authServiceSingInDidFail()
}

//   Создаём класс - сервис для авторизации и регистрации в ВК. Подписываемся под 2 делегата после NSObject
class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {
    
    //     id моего приложения
    private let appId = "51460575"
    //    Св-во с помощью которого будем инициализировать данный класс
    private let vkSdk: VKSdk
    //    Доступ к протоколу через weak для ослабления ссылки
    weak var delegate: AuthServiceDelegate?
    //    Достаём индивидуальный токен
    var token: String? {
        return VKSdk.accessToken()?.accessToken
    }
    //    Достаём ключ пользователя
    var userId: String? {
        return VKSdk.accessToken()?.userId
    }
    
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        print("VKSdk.initialized")
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    //    Проверяем доступность предыдущей сессии
    func wakeUpSession() {
        //        Создаём массив с возможными действиями
        let scope = ["offline, wall, friends"]
        
        VKSdk.wakeUpSession(scope) { [delegate] (state, error) in
            switch state {
            case .initialized:
                print("initialized")
                VKSdk.authorize(scope)
            case .authorized:
                print("authorized")
                delegate?.authServiceSingIn()
            default:
                delegate?.authServiceSingInDidFail()
            }
        }
    }
    
    //    Успешная авторизация
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        //        Если ключ существует
        if result.token != nil { 
            //       Передаём вход далее
            delegate?.authServiceSingIn()
        }
        print(#function)
    }
    
    //    В случае ошибки будет срабатывать
    func vkSdkUserAuthorizationFailed() {
        delegate?.authServiceSingInDidFail()
    }
    
    //    Готов ли SDK к работе. Открываем контроллер
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        //        Передаём через делегат параметр контроллера дальше
        delegate?.authServiceShouldShow(controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
    }
}
