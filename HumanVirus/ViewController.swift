//
//  ViewController.swift
//  HumanVirus
//
//  Created by Dmitry Malakhov on 24.09.16.
//  Copyright © 2016 Dmytro Malakhov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var game : Game
    var gameBoard : GameBoard
    var timer : Timer?
    var running = false {
        willSet {
            let buttonLabel = newValue ? "STOP" : "START"
            startButton.setTitle(buttonLabel, for: .normal)
        }
    }
    var steps = 0
    var inputField: UITextField?
   
    
    @IBOutlet weak var boardView: UIView!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func handleResetTapped(_ sender: UIButton) {
        game = Game.newGame()
        gameBoard.game = game
        gameBoard.setNeedsDisplay()
    }
    
    @IBAction func handleStartStop(_ sender: UIButton) {
        startTimer()
    }
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: game.timeStep, target: self, selector: #selector(ViewController.moment), userInfo: nil, repeats: true)
        } else {
            stopGame()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        game = Game.newGame()
        gameBoard = GameBoard(createGame: game)
        
        super.init(coder: aDecoder)
    }
    
    convenience init(){
        self.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color = UIColor(red: 55/255, green: 55/255, blue: 55/255, alpha: 1.0)
        boardView.backgroundColor = UIColor.white
        view.backgroundColor = color
        
        gameBoard.frame = CGRect(x: 0, y: 0, width: game.box.width + game.radius, height: game.box.height + game.radius)
        
        boardView.addSubview(gameBoard)
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.killMan(_:)))
        gameBoard.addGestureRecognizer(tap)

    }
    
    func killMan(_ recognizer: UIGestureRecognizer) {
        let position = recognizer.location(in: gameBoard)
        let point = Position(x: Double(position.x), y: Double(position.y))
        func findClosestManIndex() -> Int {
            var closestDistanse = 1000000.0
            var index = 0
            for (i,man) in game.arrayOfHumans.enumerated() {
                if closestDistanse > man.distanceToPoint(point) {
                    closestDistanse = man.distanceToPoint(point)
                    index = i
                }
            }
            return index
        }
        let index = findClosestManIndex()
        game.arrayOfHumans[index].changeStateTo(.dead)
        gameBoard.setNeedsDisplay()
    }
    
    func stopGame() {
        
        timer?.invalidate()
        timer = nil
        running = false
    }

    func moment() {
        self.steps = steps + 1
        print("steps : \(steps)")
        if running == false {
//            resetButton.titleLabel!.text = "Stop"
            running = true
        }
        
        game.nextEvolution()
        
        gameBoard.setNeedsDisplay()
        
    }
}

