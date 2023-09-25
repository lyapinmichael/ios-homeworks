//
//  SceneDelegate.swift
//  Navigation
//
//  Created by Ляпин Михаил on 09.02.2023.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var mainCoordinator: MainCoorditanor?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        
        UNUserNotificationCenter.current().delegate = self
        
        let factory = AppFactory(userService: CurrentUserService())
        let mainCoordinator = MainCoorditanor(factory: factory)
        
        window = UIWindow(windowScene: scene)
        self.mainCoordinator = mainCoordinator
        
        let configuration = AppConfigutation.starships
        NetworkService.request(requestURL: configuration.url("22"), completion: { result in
            switch result {
            case .success(let loadedData):
                switch configuration  {
                case .planets:
                    if let planetName = loadedData["name"] {
                        print("Welcome to planet \(planetName)!")
                    }
                case .people:
                    if let personName = loadedData["name"] {
                        print("Meet \(personName)!")
                    }
                case .starships:
                    if let starshipName = loadedData["name"], let starshipCost = loadedData["cost_in_credits"] {
                        print("Look! \(starshipName) just flew by. It costs \(starshipCost) credits btw.")
                    }
                }
            case .failure(let error):
                print("Something went wrong: \n\n\(error)")
            }
        })
        
        window?.rootViewController = mainCoordinator.start()
        window?.makeKeyAndVisible()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
        let _ = try? Auth.auth().signOut()
        
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


}

extension SceneDelegate: UNUserNotificationCenterDelegate {
 
            
            func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
                
                switch response.actionIdentifier {
                case "checkForUpdates":
                    print("checking for updates...")
                    window?.rootViewController?.present(InfoViewController(), animated: true)
                default:
                    break
                }
                
                completionHandler()
            }
        }
