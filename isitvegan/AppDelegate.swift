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
        compositionRoot.quickActionEvent.dispatch(quickActionFromLaunchOptions(launchOptions))

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = compositionRoot.createRootView()
        window?.tintColor = .veganGreen
        window?.makeKeyAndVisible()

        return true
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        compositionRoot.quickActionEvent.dispatch(shortcutItemTypeToQuickAction(shortcutItem.type))
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
        appDelegate.compositionRoot.quickActionEvent.dispatch(
            shortcutItemTypeToQuickAction(connectionOptions.shortcutItem?.type ?? ""))
    }

    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.compositionRoot.quickActionEvent.dispatch(
            shortcutItemTypeToQuickAction(shortcutItem.type))
        completionHandler(true)
    }
}

fileprivate func initializeWindow(_ window: UIWindow?, appDelegate: AppDelegate) {
    window?.rootViewController = appDelegate.compositionRoot.createRootView()
    window?.tintColor = .veganGreen
    window?.makeKeyAndVisible()
}

fileprivate func quickActionFromLaunchOptions(
    _ launchOptions: [UIApplication.LaunchOptionsKey : Any]?
) -> QuickAction {
    return shortcutItemFromLaunchOptions(launchOptions)
        .map { shortcutItemTypeToQuickAction($0.type) }
        ?? .None
}

fileprivate func shortcutItemTypeToQuickAction(_ type: String) -> QuickAction {
    switch type {
    case "SearchByNameAction":
        return .SearchByName
    case "SearchByENumberAction":
        return .SearchByENumber
    default:
        return .None
    }
}

fileprivate func shortcutItemFromLaunchOptions(
    _ launchOptions: [UIApplication.LaunchOptionsKey : Any]?
) -> UIApplicationShortcutItem? {
    return launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem
}
