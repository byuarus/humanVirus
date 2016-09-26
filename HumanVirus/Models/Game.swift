//
//  Game.swift
//  HumanVirus
//
//  Created by Dmitry Malakhov on 24.09.16.
//  Copyright © 2016 Dmytro Malakhov. All rights reserved.
//
import UIKit


class Game {
    
    var arrayOfHumans: [Human] = []
    let timeStep: Double
    let box: CGRect
    let radius: Double
    
    private let numberOfHumans: Int
    private let maxSpeed: Double
    private let timeToChangeState: Double
    
    init(numberOfHumans: Int, box: CGRect, maxSpeed: Double, radius: Double, timeToChangeState: Double, timeStep: Double){
        
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
             box: CGRect(origin:CGPoint.zero, size:CGSize(width: 200, height: 200)),
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
        
        var newArrayOfHumans: [Human] = []
        
        for (i,man) in arrayOfHumans.enumerated() {
            
            var changeToState: State = .none
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
        
        var array: [Human] = []
        
        for _ in 0 ..< numberOfHumans {
            let man = Human(box: box, radius: radius, maxSpeed: maxSpeed, timeToChangeState: timeToChangeState)
            array.append(man)
        }
        
        return array
    }
}
