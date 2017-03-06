//
//  ViewController.swift
//  TicTacToe
//
//  Created by Gabe Shahbazian on 12/28/15.
//  Copyright © 2015 gabeshahbazian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate var game = StateMachine<GameState>(initialState: .newGame)
    fileprivate var currentBoard = Board() {
        didSet {
            drawCurrentBoard()
        }
    }
    
    /// You can change these two types to any Player type to play different opponents
    var xPlayer = HumanPlayer(pieceType: .xPiece)
    var oPlayer = UnbeatableComputerPlayer(pieceType: .oPiece)
    
    fileprivate var boardView: BoardView?
    fileprivate lazy var winnerLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate lazy var newGameButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("New Game", comment: ""), for: UIControlState())
        button.setTitleColor(UIColor.blue, for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.isHidden = true
        button.addTarget(self, action: #selector(ViewController.newGamePressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(winnerLabel)
        winnerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        winnerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30.0).isActive = true
        
        view.addSubview(newGameButton)
        newGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newGameButton.topAnchor.constraint(equalTo: winnerLabel.bottomAnchor, constant: 10.0).isActive = true
        
        game.transitionObservation = {[unowned self] (from: GameState, to: GameState) -> () in
            switch (from, to) {
            case (_, .newGame):
                self.currentBoard = Board()
                self.winnerLabel.isHidden = true
                self.newGameButton.isHidden = true
                self.game.state = .xPlayersTurn
            case (.newGame, .xPlayersTurn):
                self.currentBoard = Board()
                fallthrough
            case (_, .xPlayersTurn):
                if self.xPlayer.canMakeOwnMove {
                    let move = self.xPlayer.makeMoveOnBoard(self.currentBoard, column: nil, row: nil)
                    if move.0 {
                        self.playerMadeMove(move.1, nextState: .oPlayersTurn)
                    }
                }
            case (_, .oPlayersTurn):
                if self.oPlayer.canMakeOwnMove {
                    let move = self.oPlayer.makeMoveOnBoard(self.currentBoard, column: nil, row: nil)
                    if move.0 {
                        self.playerMadeMove(move.1, nextState: .xPlayersTurn)
                    }
                }
            case (_, .gameOver):
                switch self.currentBoard.winningPiece {
                case .some(.xPiece):
                    self.winnerLabel.text = NSLocalizedString("X Wins!", comment: "")
                case .some(.oPiece):
                    self.winnerLabel.text = NSLocalizedString("O Wins!", comment: "")
                case .none:
                    self.winnerLabel.text = NSLocalizedString("Cats Game", comment: "")
                }
                
                self.winnerLabel.isHidden = false
                self.newGameButton.isHidden = false
            }
        }
        
        game.state = .xPlayersTurn
    }
    
    func playerMadeMove(_ nextBoard: Board, nextState: GameState) {
        currentBoard = nextBoard
        
        let winningPiece = currentBoard.gameIsOver()
        if winningPiece.0 {
            game.state = .gameOver
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
        nextBoardView.backgroundColor = UIColor.gray
        view.addSubview(nextBoardView)
        
        nextBoardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextBoardView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        boardView = nextBoardView
    }
    
    func newGamePressed() {
        game.state = .newGame
    }
}

extension ViewController: BoardDelegate {
    func boardView(_ boardView: BoardView, selectedSquareAtColumn column: Int, row: Int) {
        var playersTurn: Player?
        var nextState = GameState.gameOver
        
        switch game.state {
        case .xPlayersTurn:
            playersTurn = xPlayer
            nextState = .oPlayersTurn
        case .oPlayersTurn:
            playersTurn = oPlayer
            nextState = .xPlayersTurn
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

