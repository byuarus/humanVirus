//
//  GameBoard.swift
//  HumanVirus
//
//  Created by Dmitry Malakhov on 24.09.16.
//  Copyright © 2016 Dmytro Malakhov. All rights reserved.
//

import UIKit

class GameBoard: UIView {

    private var game: Game
    
    init(createGame: Game) {
        game = createGame
        super.init(frame: game.box)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.clear(rect)
        
        for man in game.arrayOfHumans {
            currentContext?.setFillColor(man.state.color.cgColor)
            let manRect = CGRect(origin: man.position,
                                 size: CGSize(width: man.radius, height: man.radius))
            currentContext?.fillEllipse(in: manRect)
        }
    }
    
    func setNewGame(_ game: Game) {
        self.game = game
    }
}
