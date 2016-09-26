//
//  Math.swift
//  HumanVirus
//
//  Created by Dmitry Malakhov on 25.09.16.
//  Copyright © 2016 Dmytro Malakhov. All rights reserved.
//

import UIKit

func RANDOM(_ maxValue: Double) -> Double {
    return maxValue * (Double(arc4random()) / Double(UINT32_MAX))
}

func RANDOM(_ maxValue: CGFloat) -> Double {
    return Double(maxValue) * (Double(arc4random()) / Double(UINT32_MAX))
}
