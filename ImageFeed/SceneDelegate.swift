//
//  SceneDelegate.swift
//  ImageFeed
//
//  Created by PlAdmin on 23.01.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let splashViewController = SplashViewController()
        window?.rootViewController = splashViewController
        
        let navigationController = UINavigationController(rootViewController: splashViewController)
        
        window?.rootViewController = navigationController
        
        window?.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
