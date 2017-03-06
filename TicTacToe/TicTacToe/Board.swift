//
//  Board.swift
//  TicTacToe
//
//  Created by Gabe Shahbazian on 12/28/15.
//  Copyright © 2015 gabeshahbazian. All rights reserved.
//

import Foundation

let boardWidth = 3

enum Piece {
    case xPiece
    case oPiece
}

struct Space: Equatable {
    let piece: Piece?
}

func ==(lhs: Space, rhs: Space) -> Bool {
    guard let leftPiece = lhs.piece else {
        return false
    }
    
    guard let rightPiece = rhs.piece else {
        return false
    }
    
    return leftPiece == rightPiece
}

enum DiagnalDirection {
    case topLeft
    case topRight
}

struct Board: CustomDebugStringConvertible {
    fileprivate(set) var board: [[Space]]
    var numberOfMovesMade = 0

    fileprivate(set) var winningPiece: Piece?
    fileprivate(set) var winningRow: Int?
    fileprivate(set) var winningColumn: Int?
    fileprivate(set) var winningDiagnal: DiagnalDirection?
    
    init() {
        var emptyBoard = [[Space]]()
        for _ in 0..<boardWidth {
            var emptyRow = [Space]()
            for _ in 0..<boardWidth {
                emptyRow.append(Space(piece: nil))
            }
            emptyBoard.append(emptyRow)
        }
        
        board = emptyBoard
    }
    
    mutating func putPieceAtSpace(_ piece: Piece, column: Int, row: Int) -> Bool {
        guard row < board.count else {
            return false
        }
        
        let rowSpaces = board[row]
        
        guard column < rowSpaces.count else {
            return false
        }
        
        guard rowSpaces[column].piece == nil else {
            return false
        }
        
        board[row][column] = Space(piece: piece)
        numberOfMovesMade += 1
        
        if numberOfMovesMade >= (2 * boardWidth) - 1 {
            var rowWins = true
            let rowSpaces = board[row]
            for columnIndex in 0..<(rowSpaces.count - 1) {
                rowWins = rowWins && (rowSpaces[columnIndex] == rowSpaces[columnIndex + 1])
            }
            if rowWins {
                winningRow = row
                winningPiece = piece
            }
            
            var columnWins = true
            for rowIndex in 0..<(board.count - 1) {
                columnWins = columnWins && (board[rowIndex][column] == board[rowIndex + 1][column])
            }
            if columnWins {
                winningColumn = column
                winningPiece = piece
            }
            
            if (column == 0 && row == 0) || (column == ((boardWidth - 1) / 2) && row == ((boardWidth - 1) / 2)) || (column == (boardWidth - 1) && row == (boardWidth - 1)) {
                var topLeftDiagnalWins = true
                for index in 0..<(boardWidth - 1) {
                    topLeftDiagnalWins = topLeftDiagnalWins && (board[index][index] == board[index + 1][index + 1])
                }
                if topLeftDiagnalWins {
                    winningDiagnal = .topLeft
                    winningPiece = piece
                }
            }
            
            if (column == (boardWidth - 1) && row == 0) || (column == ((boardWidth - 1) / 2) && row == ((boardWidth - 1) / 2)) || (column == 0 && row == (boardWidth - 1)) {
                var topRightDiagnalWins = true
                for index in 0..<(boardWidth - 1) {
                    topRightDiagnalWins = topRightDiagnalWins && (board[boardWidth - 1 - index][index] == board[boardWidth - 2 - index][index + 1])
                }
                if topRightDiagnalWins {
                    winningDiagnal = .topRight
                    winningPiece = piece
                }
            }
        }
        
        return true
    }
    
    func gameIsOver() -> (Bool, Piece?) {
        guard numberOfMovesMade >= (2 * boardWidth) - 1 else {
            return (false, nil)
        }
        
        if winningRow != nil || winningColumn != nil || winningDiagnal != nil {
            return (true, winningPiece)
        }
        
        if numberOfMovesMade == boardWidth * boardWidth {
            return (true, nil)
        }
        
        return (false, nil)
    }
    
    var debugDescription: String {
        get {
            var boardString = ""
            for row in board {
                boardString += "\n"
                for space in row {
                    if let piece = space.piece {
                        boardString += (piece == .xPiece) ? " X " : " O "
                    } else {
                        boardString += " _ "
                    }
                }
            }
            return boardString
        }
    }
}
