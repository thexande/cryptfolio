//
//  AppDelegate.swift
//  cryptotracker
//
//  Created by Alexander Murphy on 11/24/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import UIKit
import RealmSwift

struct StyleConstants {
    struct color {
        static let primaryGreen: UIColor = UIColor(hex: "4A9D86")
        static let emerald: UIColor = UIColor(hex: "65C87A")
        static let primaryRed: UIColor = UIColor(hex: "D65745")
        static let orange: UIColor = UIColor(hex: "E79F3C")
        static let purple: UIColor = UIColor(hex: "925EB1")
        static let bitOrange: UIColor = UIColor(hex: "E9973D")
        static let primaryGray: UIColor = UIColor(hex: "F0EFF4")
        static let secondaryGray: UIColor = UIColor(hex: "9B9B9C")
    }
}

protocol AppCoordinatorActionsDispatching: AnyObject {
    func userDidShake()
}

enum Theme {
    case light
    case dark
}

final class Themer {
    static let shared = Themer()
    // default theme
    var currentTheme: Theme = .light
}

final class AppCoordinator {
    
    private var root = UINavigationController(rootViewController: MarketViewController()) {
        didSet {
            if
                let app = UIApplication.shared.delegate as? AppDelegate,
                let window = app.window {
                window.switchRootViewController(root)
            }
        }
    }
    
    // default theme
    private var currentTheme: Theme = .light {
        didSet {
            setAppearance(with: currentTheme)
            Themer.shared.currentTheme = currentTheme
            root = UINavigationController(rootViewController: MarketViewController())
        }
    }
    
    init() {
        (root.viewControllers.first as? MarketViewController)?.appCoordinatorDispatch = self
    }
    
    func rootViewController() -> UIViewController {
        // configure with default theme
        setAppearance(with: currentTheme)
        Themer.shared.currentTheme = currentTheme
        return root
    }
    
    
    private func setAppearance(with theme: Theme) {
        
        let tint: UIColor
        let background: UIColor
        let style: UIBarStyle
        let tableBackground: UIColor
        
        switch theme {
        case .dark:
            tint = StyleConstants.color.purple
            background = .black
            tableBackground = .darkModeTableBackground()
            style = .black
            UITextField.appearance().keyboardAppearance = .dark
        case .light:
            tint = .blue
            background = .white
            tableBackground = .white
            style = .default
            UITextField.appearance().keyboardAppearance = .light
        }
        
        UINavigationBar.appearance().tintColor = tint
        UINavigationBar.appearance().barStyle = style
        
        UITabBar.appearance().barStyle = style
        UITabBar.appearance().tintColor = tint
        
        UITextField.appearance().tintColor = tint
        UISearchBar.appearance().tintColor = tint
        
        UITableViewCell.appearance().backgroundColor = background
        UITableView.appearance().backgroundColor = tableBackground
    }
}

extension AppCoordinator: AppCoordinatorActionsDispatching {
    func userDidShake() {
        switch currentTheme {
        case .dark:
            currentTheme = .light
        case .light:
            currentTheme = .dark
        }
    }
}




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let coordinator = AppCoordinator()


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = coordinator.rootViewController()
        window?.makeKeyAndVisible()
        
        do {
            let realm = try Realm()
            debugPrint("Path to realm file: " + realm.configuration.fileURL!.absoluteString)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

