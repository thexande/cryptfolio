//
//  MyHoldingsViewController.swift
//  cryptotracker
//
//  Created by Alexander Murphy on 11/24/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit

class MyHoldingsViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "my holdings".uppercased()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didPressAdd))
    }
    
    @objc func didPressAdd() {
        
    }
}
