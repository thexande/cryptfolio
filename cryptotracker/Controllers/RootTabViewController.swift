//
//  ViewController.swift
//  cryptotracker
//
//  Created by Alexander Murphy on 11/24/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift
import RealmSwift

class RootTabViewController: UITabBarController {
    let tabOneItem: UIViewController = {
        let vc = UINavigationController(rootViewController: MarketViewController())
        let icon = FontAwesomeHelper.iconToImage(icon: FontAwesome.chartLine, color: .black, width: 35, height: 35)
        let item = UITabBarItem(title: "market".uppercased(), image: icon, selectedImage: icon)
        vc.navigationBar.prefersLargeTitles = true
        vc.navigationItem.largeTitleDisplayMode = .always
        vc.tabBarItem = item
        return vc
    }()
    
    let tabTwoItem: UIViewController = {
        let vc = UINavigationController(rootViewController: MyHoldingsViewController())
        let icon = FontAwesomeHelper.iconToImage(icon: FontAwesome.moneyBill, color: .black, width: 35, height: 35)
        let item = UITabBarItem(title: "my holdings".uppercased(), image: icon, selectedImage: icon)
        vc.navigationBar.prefersLargeTitles = true
        vc.navigationItem.largeTitleDisplayMode = .always
        vc.tabBarItem = item
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.tabBar.backgroundColor = StyleConstants.color.primary_red
        //        self.tabBar.tintColor = .white
        self.viewControllers = [tabOneItem, tabTwoItem]
        
        do {
            let realm = try Realm()
            debugPrint("Path to realm file: " + realm.configuration.fileURL!.absoluteString)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
