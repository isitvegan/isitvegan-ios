import Foundation
import UIKit

class DefaultSceneDelegate: UIResponder {
    var window: UIWindow?
}

extension DefaultSceneDelegate: UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        window = UIWindow(windowScene: scene as! UIWindowScene)
        window!.rootViewController = RootViewController()
        window!.makeKeyAndVisible()
    }
}
