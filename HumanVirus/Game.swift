//
//  Game.swift
//  HumanVirus
//
//  Created by Dmitry Malakhov on 24.09.16.
//  Copyright © 2016 Dmytro Malakhov. All rights reserved.
//
import UIKit

func RANDOM(_ maxValue:Double) -> Double{
    return maxValue * (Double(arc4random()) / Double(UINT32_MAX))
}

enum State {
    case dead
    case sick
    case healthy
    case none
}

struct Position {
    var x : Double
    var y : Double
}

struct Speed {
    var x : Double
    var y : Double
}

struct Box {
    var width : Double
    var height : Double
}

struct Human {
    var state : State
    var prevState : State
    var position : Position
    var speed : Speed
    var timeInState : Double
    let timeToChangeState : Double
    let radius : Double
    
    init(box:Box, radius: Double, maxSpeed: Double, timeToChangeState: Double = 5) {
        
        self.position = Position(x: RANDOM(box.width), y: RANDOM(box.height))
        self.speed = Speed(x: -maxSpeed + RANDOM(maxSpeed * 2), y: -maxSpeed + RANDOM(maxSpeed * 2))
        self.radius = radius
        self.timeInState = 0
        self.timeToChangeState = timeToChangeState
        self.prevState = .healthy
        self.state = .healthy
    }
    
    mutating func changeStateTo(_ state:State) {
        self.state = state
    }
    
    func intersectsWith(_ otherMan:Human) -> Bool {
        let distance = self.distanceToPoint(otherMan.position)
        return distance < min(radius,otherMan.radius)
    }
    
    func distanceToPoint(_ point:Position) -> Double {
        let distance = sqrt(
            (position.x - point.x)*(position.x - point.x) +
                (position.y - point.y)*(position.y - point.y)
        )
        return distance
    }

    
    func humanAfterStepInBox(_ box:Box) -> Human {
        
        let newSpeed : Speed
        
        switch (position.x + speed.x,position.y + speed.y) {
        case (0...box.height,0...box.width):
            newSpeed = speed
        case (_,0...box.width):
            newSpeed = Speed(x: -speed.x, y: speed.y)
        case (0...box.height,_):
            newSpeed = Speed(x: speed.x, y: -speed.y)
        default:
            newSpeed = Speed(x: -speed.x, y: -speed.y)
        }
        
        let newPosition : Position = Position(x: position.x + speed.x, y: position.y + speed.y)
        
        var humanAfterStep = self
        humanAfterStep.position = newPosition
        humanAfterStep.speed = newSpeed
        return humanAfterStep
    }
}

class Game {
    
    var arrayOfHumans : [Human] = []
    private let numberOfHumans : Int
    private let maxSpeed : Double
    private let timeToChangeState : Double
    let timeStep : Double
    let box : Box
    let radius : Double
    
    init(numberOfHumans:Int ,box:Box, maxSpeed:Double, radius:Double, timeToChangeState:Double, timeStep:Double){
        self.numberOfHumans = numberOfHumans
        self.box = box
        self.maxSpeed = maxSpeed
        self.radius = radius
        self.timeToChangeState = timeToChangeState
        self.timeStep = timeStep
        self.arrayOfHumans = buildArrayOfHumans()
    }
    
    class func newGame() -> Game {
        return Game(numberOfHumans: 40,
             box: Box(width:200,height:200),
             maxSpeed: 5.0,
             radius: 20.0,
             timeToChangeState: 0.2,
             timeStep: 0.05)
    }
    
    func nextEvolution() {
        makeStep()
        checkStatuses()
    }
    
    private func makeStep() {
        arrayOfHumans = arrayOfHumans.map { $0.humanAfterStepInBox(box) }
    }
    
    private func checkStatuses() {
        
        var newArrayOfHumans : [Human] = []
        for (i,man) in arrayOfHumans.enumerated() {
            
            var changeToState : State = .none
            for (j,otherMan) in arrayOfHumans.enumerated()
                where i != j && man.intersectsWith(otherMan) && man.state != .dead {
                    
                    switch otherMan.state {
                    case .dead:
                        if [.none,.dead].contains(changeToState) {
                            changeToState = .dead
                        } else {
                            changeToState = .none
                            break
                        }
                    case .healthy:
                        if [.none,.healthy].contains(changeToState) {
                            changeToState = .healthy
                        } else {
                            changeToState = .none
                            break
                        }
                    default:
                        ()
                    }
            }
            
            var updatedMan = man
            switch changeToState {
            case .dead:
                updatedMan.timeInState = min(man.timeInState - timeStep, -timeStep)
                if updatedMan.timeInState <= -man.timeToChangeState {
                    switch man.state {
                    case .healthy:
                        updatedMan.state = .sick
                    case .sick:
                        updatedMan.state = .dead
                    default:
                        ()
                    }
                    updatedMan.timeInState = 0
                }
            case .healthy:
                updatedMan.timeInState = max(man.timeInState + timeStep, timeStep)
                if updatedMan.timeInState <= man.timeToChangeState {
                    updatedMan.state = .healthy
                    updatedMan.timeInState = 0
                }
            default:
                ()
            }
            
            newArrayOfHumans.append(updatedMan)
        }
        arrayOfHumans = newArrayOfHumans
    }
    
    private func buildArrayOfHumans() -> [Human] {
        
        var array:[Human] = []
        
        for _ in 0 ..< numberOfHumans {
            
            let man = Human(box: box, radius: radius, maxSpeed: maxSpeed, timeToChangeState: timeToChangeState)
            array.append(man)
        }
        
        return array
    }
}
