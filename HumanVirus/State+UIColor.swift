//
//  State+UIColor.swift
//  HumanVirus
//
//  Created by Dmitry Malakhov on 25.09.16.
//  Copyright © 2016 Dmytro Malakhov. All rights reserved.
//

import UIKit

extension State {
    var color: UIColor {
        switch self {
        case .dead:
            return UIColor.red
        case .sick:
            return UIColor.brown
        case .healthy:
            return UIColor.green
        default:
            return UIColor.white
        }
    }
}
