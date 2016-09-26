//
//  Human.swift
//  HumanVirus
//
//  Created by Dmitry Malakhov on 25.09.16.
//  Copyright © 2016 Dmytro Malakhov. All rights reserved.
//

import UIKit

enum State {
    case dead
    case sick
    case healthy
    case none
}

struct Human {
    
    var state: State
    var position: CGPoint
    var speed: CGVector
    var timeInState: Double
    let timeToChangeState: Double
    let radius: Double
    
    
    init(box: CGRect, radius: Double, maxSpeed: Double, timeToChangeState: Double = 5) {
        
        self.position = CGPoint(x: RANDOM(box.width), y: RANDOM(box.height))
        self.speed = CGVector(dx: -maxSpeed + RANDOM(maxSpeed * 2), dy: -maxSpeed + RANDOM(maxSpeed * 2))
        self.radius = radius
        self.timeInState = 0
        self.timeToChangeState = timeToChangeState
        self.state = .healthy
    }
    
    mutating func changeStateTo(_ state: State) {
        self.state = state
    }
    
    func intersectsWith(_ otherMan: Human) -> Bool {
        
        let distance = self.position.distanceToPoint(otherMan.position)
        return Double(distance) < min(radius, otherMan.radius)
    }
    
    func humanAfterStepInBox(_ box: CGRect) -> Human {
        
        let newSpeed: CGVector
        
        switch (position.x + speed.dx, position.y + speed.dy) {
        case (0...box.height, 0...box.width):
            newSpeed = speed
        case (_, 0...box.width):
            newSpeed = CGVector(dx: -speed.dx, dy: speed.dy)
        case (0...box.height, _):
            newSpeed = CGVector(dx: speed.dx, dy: -speed.dy)
        default:
            newSpeed = CGVector(dx: -speed.dx, dy: -speed.dy)
        }
        
        let newPosition = CGPoint(x: position.x + speed.dx, y: position.y + speed.dy)
        
        var humanAfterStep = self
        humanAfterStep.position = newPosition
        humanAfterStep.speed = newSpeed
        return humanAfterStep
    }
}
