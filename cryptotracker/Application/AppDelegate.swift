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

final class AppCoordinator {
    
    private let root: UINavigationController
    
    init() {
        root = UINavigationController(rootViewController: MarketViewController())
    }
    
    func rootViewController() -> UIViewController {
        return root
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
}

