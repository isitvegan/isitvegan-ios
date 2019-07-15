import Foundation
import UIKit
import CoreData

class DefaultSceneDelegate: UIResponder {
    var window: UIWindow?
}

@available(iOS 13.0, *)
extension DefaultSceneDelegate: UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        window = UIWindow(windowScene: scene as! UIWindowScene)
        window?.rootViewController = appDelegate.compositionRoot.createRootView()
        window?.tintColor = .veganGreen
        window?.makeKeyAndVisible()
    }
}
