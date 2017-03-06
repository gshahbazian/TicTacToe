//
//  GameState.swift
//  TicTacToe
//
//  Created by Gabe Shahbazian on 12/28/15.
//  Copyright © 2015 gabeshahbazian. All rights reserved.
//

import Foundation

enum GameState: State {
    case newGame
    case xPlayersTurn
    case oPlayersTurn
    case gameOver
    
    func shouldTransition(_ toState: GameState) -> Bool {
        switch self {
        case .newGame:
            return toState == .xPlayersTurn
        case .xPlayersTurn:
            return toState == .oPlayersTurn || toState == .gameOver
        case .oPlayersTurn:
            return toState == .xPlayersTurn || toState == .gameOver
        case .gameOver:
            return toState == .newGame
        }
    }
}
