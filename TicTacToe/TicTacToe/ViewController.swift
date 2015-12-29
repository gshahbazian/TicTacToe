//
//  ViewController.swift
//  TicTacToe
//
//  Created by Gabe Shahbazian on 12/28/15.
//  Copyright © 2015 gabeshahbazian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var game = StateMachine<GameState>(initialState: .NewGame)
    private var currentBoard = Board() {
        didSet {
            drawCurrentBoard()
        }
    }
    
    /// You can change these two types to any Player type to play different opponents
    var xPlayer = HumanPlayer(pieceType: .XPiece)
    var oPlayer = UnbeatableComputerPlayer(pieceType: .OPiece)
    
    private var boardView: BoardView?
    private lazy var winnerLabel: UILabel = {
        let label = UILabel()
        label.hidden = true
        label.font = UIFont.systemFontOfSize(24.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var newGameButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("New Game", comment: ""), forState: .Normal)
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        button.hidden = true
        button.addTarget(self, action: "newGamePressed", forControlEvents: .TouchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(winnerLabel)
        winnerLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        winnerLabel.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 30.0).active = true
        
        view.addSubview(newGameButton)
        newGameButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        newGameButton.topAnchor.constraintEqualToAnchor(winnerLabel.bottomAnchor, constant: 10.0).active = true
        
        game.transitionObservation = {[unowned self] (from: GameState, to: GameState) -> () in
            switch (from, to) {
            case (_, .NewGame):
                self.currentBoard = Board()
                self.winnerLabel.hidden = true
                self.newGameButton.hidden = true
                self.game.state = .XPlayersTurn
            case (.NewGame, .XPlayersTurn):
                self.currentBoard = Board()
                fallthrough
            case (_, .XPlayersTurn):
                if self.xPlayer.canMakeOwnMove {
                    let move = self.xPlayer.makeMoveOnBoard(self.currentBoard, column: nil, row: nil)
                    if move.0 {
                        self.playerMadeMove(move.1, nextState: .OPlayersTurn)
                    }
                }
            case (_, .OPlayersTurn):
                if self.oPlayer.canMakeOwnMove {
                    let move = self.oPlayer.makeMoveOnBoard(self.currentBoard, column: nil, row: nil)
                    if move.0 {
                        self.playerMadeMove(move.1, nextState: .XPlayersTurn)
                    }
                }
            case (_, .GameOver):
                switch self.currentBoard.winningPiece {
                case .Some(.XPiece):
                    self.winnerLabel.text = NSLocalizedString("X Wins!", comment: "")
                case .Some(.OPiece):
                    self.winnerLabel.text = NSLocalizedString("O Wins!", comment: "")
                case .None:
                    self.winnerLabel.text = NSLocalizedString("Cats Game", comment: "")
                }
                
                self.winnerLabel.hidden = false
                self.newGameButton.hidden = false
            }
        }
        
        game.state = .XPlayersTurn
    }
    
    func playerMadeMove(nextBoard: Board, nextState: GameState) {
        currentBoard = nextBoard
        
        let winningPiece = currentBoard.gameIsOver()
        if winningPiece.0 {
            game.state = .GameOver
        } else {
            game.state = nextState
        }
    }
    
    func drawCurrentBoard() {
        print("\n")
        print("STATE: \(game.state)")
        print("BOARD: \n \(self.currentBoard)")
        
        if let currentBoardView = boardView {
            currentBoardView.removeFromSuperview()
        }
        
        let nextBoardView = BoardView(board: currentBoard, delegate: self)
        nextBoardView.translatesAutoresizingMaskIntoConstraints = false
        nextBoardView.backgroundColor = UIColor.grayColor()
        view.addSubview(nextBoardView)
        
        nextBoardView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        nextBoardView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        
        boardView = nextBoardView
    }
    
    func newGamePressed() {
        game.state = .NewGame
    }
}

extension ViewController: BoardDelegate {
    func boardView(boardView: BoardView, selectedSquareAtColumn column: Int, row: Int) {
        var playersTurn: Player?
        var nextState = GameState.GameOver
        
        switch game.state {
        case .XPlayersTurn:
            playersTurn = xPlayer
            nextState = .OPlayersTurn
        case .OPlayersTurn:
            playersTurn = oPlayer
            nextState = .XPlayersTurn
        default: break
        }
        
        if let player = playersTurn {
            let move = player.makeMoveOnBoard(self.currentBoard, column: column, row: row)
            if move.0 {
                self.playerMadeMove(move.1, nextState: nextState)
            }
        }
    }
}

