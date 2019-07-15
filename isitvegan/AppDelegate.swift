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
        setupDatabase()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = compositionRoot.createRootView()
        window?.tintColor = .veganGreen
        window?.makeKeyAndVisible()

        return true
    }

    func applicationDidFinishLaunching(_ application: UIApplication) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = compositionRoot.createRootView()
        window?.tintColor = .veganGreen
        window?.makeKeyAndVisible()
    }

    private func setupDatabase() {
        try! compositionRoot.sqliteStorage.setupSchema()
    }
}

