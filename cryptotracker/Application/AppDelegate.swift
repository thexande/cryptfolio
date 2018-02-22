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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let vc = UINavigationController(rootViewController: MarketViewController())
        vc.navigationBar.prefersLargeTitles = true
        vc.navigationItem.largeTitleDisplayMode = .always
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
//        UIApplication.shared.statusBarStyle = .lightContent
//        let navigationBarAppearance = UINavigationBar.appearance()
//        navigationBarAppearance.barTintColor = StyleConstants.color.primaryGreen
//        navigationBarAppearance.tintColor = UIColor.white
        
        // change navigation item title color
//        navigationBarAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
//        navigationBarAppearance.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
//        let tabBarAppear = UITabBar.appearance()
//        tabBarAppear.barTintColor = StyleConstants.color.primaryGreen
//        tabBarAppear.tintColor = UIColor.white
        
        
        
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

