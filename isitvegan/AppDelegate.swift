import UIKit
import SQLite
import CoreSpotlight
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var compositionRoot: CompositionRoot = CompositionRoot()
    var window: UIWindow?

    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = compositionRoot.createRootView()
        window?.tintColor = .veganGreen
        window?.makeKeyAndVisible()

        return true
    }

    func applicationDidFinishLaunching(_ application: UIApplication) {
        window = UIWindow(frame: UIScreen.main.bounds)
        initializeWindow(window, appDelegate: self)
    }
}

class DefaultSceneDelegate: UIResponder {
    var window: UIWindow?
}

@available(iOS 13.0, *)
extension DefaultSceneDelegate: UIWindowSceneDelegate {
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        window = UIWindow(windowScene: scene as! UIWindowScene)
        initializeWindow(window, appDelegate: appDelegate)
    }
}

fileprivate func initializeWindow(_ window: UIWindow?, appDelegate: AppDelegate) {
    window?.rootViewController = appDelegate.compositionRoot.createRootView()
    window?.tintColor = .veganGreen
    window?.makeKeyAndVisible()
}
