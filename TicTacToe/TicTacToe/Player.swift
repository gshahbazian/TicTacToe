//
//  Player.swift
//  TicTacToe
//
//  Created by Gabe Shahbazian on 12/28/15.
//  Copyright © 2015 gabeshahbazian. All rights reserved.
//

import Foundation

protocol Player {
    init(pieceType: Piece)
    var pieceType: Piece { get }
    
    var canMakeOwnMove: Bool { get }
    func makeMoveOnBoard(board: Board, column: Int?, row: Int?) -> (Bool, Board)
}

struct RandomComputerPlayer: Player {
    let pieceType: Piece
    let canMakeOwnMove = true
    
    init(pieceType: Piece) {
        self.pieceType = pieceType
    }
    
    func makeMoveOnBoard(board: Board, column: Int?, row: Int?) -> (Bool, Board) {
        var didMakeMove = false
        var nextBoard = board
        while !didMakeMove {
            let x = arc4random_uniform(3)
            let y = arc4random_uniform(3)
            didMakeMove = nextBoard.putPieceAtSpace(pieceType, column: Int(x), row: Int(y))
        }
        return (true, nextBoard)
    }
}

struct UnbeatableComputerPlayer: Player {
    let pieceType: Piece
    let canMakeOwnMove = true
    
    init(pieceType: Piece) {
        self.pieceType = pieceType
    }
    
    func makeMoveOnBoard(board: Board, column: Int?, row: Int?) -> (Bool, Board) {
        return (true, minmax(board, currentPlayersPiece: pieceType).1)
    }
    
    /// Minmax algorithm described here http://neverstopbuilding.com/minimax
    func minmax(board: Board, currentPlayersPiece: Piece) -> (Int, Board) {
        if board.gameIsOver().0 {
            return (score(board), board)
        }
        
        var scores = [Int]()
        var possibleBoards = [Board]()
        
        for rowIndex in 0..<board.board.count {
            for columnIndex in 0..<board.board[rowIndex].count {
                var possibleBoard = board
                if possibleBoard.putPieceAtSpace(currentPlayersPiece, column: columnIndex, row: rowIndex) {
                    possibleBoards.append(possibleBoard)
                }
            }
        }
        
        for possibleBoard in possibleBoards {
            let nextPiece = currentPlayersPiece == .XPiece ? Piece.OPiece : Piece.XPiece
            scores.append(minmax(possibleBoard, currentPlayersPiece: nextPiece).0)
        }
        
        if currentPlayersPiece == pieceType {
            let (position, max) = scores.enumerate().reduce((-1, Int.min), combine: {
                $0.1 > $1.1 ? $0 : $1
            })
            return (max, possibleBoards[position])
        } else {
            let (position, min) = scores.enumerate().reduce((-1, Int.max), combine: {
                $0.1 < $1.1 ? $0 : $1
            })
            return (min, possibleBoards[position])
        }
    }
    
    func score(board: Board) -> Int {
        if let winningPiece = board.winningPiece {
            return winningPiece == pieceType ? 10 : -10
        }
        
        return 0
    }
}

struct HumanPlayer: Player {
    let pieceType: Piece
    let canMakeOwnMove = false
    
    init(pieceType: Piece) {
        self.pieceType = pieceType
    }
    
    func makeMoveOnBoard(board: Board, column: Int?, row: Int?) -> (Bool, Board) {
        guard let unwrappedColumn = column, let unwrappedRow = row else {
            return (false, board)
        }
        
        var nextBoard = board
        let didPutPiece = nextBoard.putPieceAtSpace(pieceType, column: unwrappedColumn, row: unwrappedRow)
        return (didPutPiece, nextBoard)
    }
}
