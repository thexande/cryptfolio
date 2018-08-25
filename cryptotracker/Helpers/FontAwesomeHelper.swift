//
//  FontAwesomeHelper.swift
//  cryptotracker
//
//  Created by Alexander Murphy on 11/24/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

class FontAwesomeHelper {
    static func iconToImage(icon: FontAwesome, color: UIColor, width: Int, height: Int) -> UIImage {
        return UIImage.fontAwesomeIcon(name: icon, style: .solid, textColor: color, size: CGSize(width: width, height: height))
    }
}
