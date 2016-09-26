//
//  ViewController.swift
//  HumanVirus
//
//  Created by Dmitry Malakhov on 24.09.16.
//  Copyright © 2016 Dmytro Malakhov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    private var game: Game
    private var gameBoard: GameBoard
    private var timer: Timer?
    private var running = false {
        willSet {
            let buttonLabel = newValue ? "STOP" : "START"
            startButton.setTitle(buttonLabel, for: .normal)
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
        
        gameBoard.frame = CGRect(x: 0, y: 0, width: game.box.width + CGFloat(game.radius), height: game.box.height + CGFloat(game.radius))
        
        boardView.addSubview(gameBoard)
       
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(ViewController.infectMan(_:)))
        gameBoard.addGestureRecognizer(tap)
        
        running = false
    }
    
    @IBAction func handleResetTapped(_ sender: UIButton) {
        
        game = Game.newGame()
        gameBoard.setNewGame(game)
        gameBoard.setNeedsDisplay()
    }
    
    @IBAction func handleStartStop(_ sender: UIButton) {
        startTimer()
    }
    
    func startTimer() {
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: game.timeStep,
                                         target: self,
                                         selector: #selector(ViewController.moment),
                                         userInfo: nil,
                                         repeats: true)
        } else {
            stopGame()
        }
    }
    
    func infectMan(_ recognizer: UIGestureRecognizer) {
        
        let tapPosition = recognizer.location(in: gameBoard)
        
        func findClosestManIndex() -> Int {
            var closestDistanse: CGFloat = 10000
            var index = 0
            for (i,man) in game.arrayOfHumans.enumerated() {
                if closestDistanse > man.position.distanceToPoint(tapPosition) {
                    closestDistanse = man.position.distanceToPoint(tapPosition)
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

        running = true
        game.nextEvolution()
        gameBoard.setNeedsDisplay()
    }
}

