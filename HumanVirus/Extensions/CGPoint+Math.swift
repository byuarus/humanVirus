//
//  CGPoint+Math.swift
//  HumanVirus
//
//  Created by Dmitry Malakhov on 25.09.16.
//  Copyright © 2016 Dmytro Malakhov. All rights reserved.
//

import UIKit

extension CGPoint {
    func distanceToPoint(_ p: CGPoint) -> CGFloat {
        return sqrt(pow((p.x - x), 2) + pow((p.y - y), 2))
    }
}
