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
        initializeWindow(window, appDelegate: self)
        handleQuickAction(appDelegate: self, shortcutItem: shortcutItemFromLaunchOptions(launchOptions))
        return true
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        handleQuickAction(appDelegate: self, shortcutItem: shortcutItem)
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
        let appDelegate = getSharedAppDelegate()
        window = UIWindow(windowScene: scene as! UIWindowScene)
        initializeWindow(window, appDelegate: appDelegate)
        handleQuickAction(appDelegate: appDelegate, shortcutItem: connectionOptions.shortcutItem)
    }

    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        handleQuickAction(appDelegate: getSharedAppDelegate(), shortcutItem: shortcutItem)
    }
}

fileprivate func initializeWindow(_ window: UIWindow?, appDelegate: AppDelegate) {
    window?.rootViewController = appDelegate.compositionRoot.createRootView()
    window?.tintColor = .veganGreen
    window?.makeKeyAndVisible()
}

fileprivate func handleQuickAction(appDelegate: AppDelegate, shortcutItem: UIApplicationShortcutItem?) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let quickAction = shortcutItem.flatMap { item in shortcutItemTypeToQuickAction(item.type) }

    quickAction.map { quickAction in
        appDelegate.compositionRoot.quickActionEvent.dispatch(quickAction)
    }
}

fileprivate func shortcutItemTypeToQuickAction(_ type: String) -> QuickAction? {
    switch type {
    case "SearchByNameAction":
        return .SearchByName
    case "SearchByENumberAction":
        return .SearchByENumber
    default:
        return nil
    }
}

fileprivate func shortcutItemFromLaunchOptions(
    _ launchOptions: [UIApplication.LaunchOptionsKey : Any]?
) -> UIApplicationShortcutItem? {
    return launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem
}

fileprivate func getSharedAppDelegate() -> AppDelegate {
    UIApplication.shared.delegate as! AppDelegate
}
