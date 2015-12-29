//
//  GameState.swift
//  TicTacToe
//
//  Created by Gabe Shahbazian on 12/28/15.
//  Copyright © 2015 gabeshahbazian. All rights reserved.
//

import Foundation

enum GameState: State {
    case NewGame
    case XPlayersTurn
    case OPlayersTurn
    case GameOver
    
    func shouldTransition(toState: GameState) -> Bool {
        switch self {
        case .NewGame:
            return toState == .XPlayersTurn
        case .XPlayersTurn:
            return toState == .OPlayersTurn || toState == .GameOver
        case .OPlayersTurn:
            return toState == .XPlayersTurn || toState == .GameOver
        case .GameOver:
            return toState == .NewGame
        }
    }
}
