//
//  GameBoard.swift
//  HumanVirus
//
//  Created by Dmitry Malakhov on 24.09.16.
//  Copyright © 2016 Dmytro Malakhov. All rights reserved.
//

import UIKit

class GameBoard: UIView {

    var game: Game
    
    init(createGame: Game) {
        game = createGame
        super.init(frame: CGRect(x: 0,y: 0,width: CGFloat(game.box.width),height: CGFloat(game.box.height)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.clear(rect)
        func colorForState (_ state: State) -> UIColor {
            switch state {
            case .healthy:
                return .green
            case .dead:
                return .red
            case .sick,.none:
                return .brown
            }
        }
        
        func frameForHuman(_ man: Human) -> CGRect {
            return CGRect(x: CGFloat(man.position.x), y: CGFloat(man.position.y), width: CGFloat(man.radius), height: CGFloat(man.radius))
        }
        
        for man in game.arrayOfHumans {
            currentContext?.setFillColor(colorForState(man.state).cgColor)
            currentContext?.fillEllipse(in: frameForHuman(man))
        }
    }

}
