//
//  SceneDelegate.swift
//  iOS-UIKit-CoreLocation
//
//  Created by Muker on 4/1/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let useCase = CoreLocationUseCase(
            busStopInfoRepository: .init(),
            locationService: .init()
        )
        let viewModel = CoreLocationViewModel(useCase: useCase)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = CoreLocationViewController(
            viewModel: viewModel
        )
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

