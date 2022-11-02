//
//  SceneDelegate.swift
//  VKNews
//
//  Created by Rail on 25.10.2022.
//

import UIKit
import VKSdkFramework

class SceneDelegate: UIResponder, UIWindowSceneDelegate, AuthServiceDelegate {
    
    var window: UIWindow?
    //    Достаём доступ до авторизации ВК
    var authService: AuthService!
    
    //    используем Singltone
    static func shared() -> SceneDelegate {
        //        Добираемся до первой сцены
        let scene = UIApplication.shared.connectedScenes.first
        //        Добираемся до SceneDelegate
        let sceneDelegate: SceneDelegate = (scene?.delegate as? SceneDelegate)!
        return sceneDelegate
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        //        Инициализируем
        authService = AuthService()
        //        SceneDelegate будет осуществлять все делегаты
        authService.delegate = self
        //        Обращаюсь к сториборд для AuthViewController
        let authVC = UIStoryboard(name: "AuthViewController", bundle: nil).instantiateInitialViewController() as? AuthViewController
        window?.rootViewController = authVC
        window?.makeKeyAndVisible()
    }
    
    //    Для хорошего отображения url схемы вызываем
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        //        Проверяем url, который получаем
        if let url = URLContexts.first?.url {
            VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    //    MARK: - Все методы AuthServiceDelegate
    
    func authServiceShouldShow(_ viewController: UIViewController) {
        print(#function)
        //        Отображаем контроллер
        window?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    
    func authServiceSingIn() {
        print(#function)
        //        Если удаётся достать сториборд для FeedViewController
        let feedVC = UIStoryboard(name: "FeedViewController", bundle: nil).instantiateInitialViewController() as? FeedViewController
        //        То достаём window предварительно через navigationController
        let navController = UINavigationController(rootViewController: feedVC!)
        window?.rootViewController = navController
    }
    
    func authServiceSingInDidFail() {
        print(#function)
    }
}

