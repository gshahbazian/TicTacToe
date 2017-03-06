//
//  BoardView.swift
//  TicTacToe
//
//  Created by Gabe Shahbazian on 12/29/15.
//  Copyright © 2015 gabeshahbazian. All rights reserved.
//

import UIKit

let boardSquareSize = CGFloat(66.0)

protocol BoardDelegate {
    func boardView(_ boardView: BoardView, selectedSquareAtColumn column: Int, row: Int)
}

class BoardView: UIView {
    
    let board: Board
    let delegate: BoardDelegate
    
    init(board: Board, delegate: BoardDelegate) {
        self.board = board
        self.delegate = delegate
        super.init(frame: CGRect.zero)
        
        drawSquares()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize : CGSize {
        let dimension = boardSquareSize * CGFloat(board.board.count)
        return CGSize(width: dimension, height: dimension)
    }
    
    fileprivate func drawSquares() {
        for rowIndex in 0..<board.board.count {
            for columnIndex in 0..<board.board[rowIndex].count {
                let space = board.board[rowIndex][columnIndex]

                var cellTitle = "_"
                switch space.piece {
                case .some(.xPiece):
                    cellTitle = "X"
                case .some(.oPiece):
                    cellTitle = "O"
                default: break
                }
                
                let cellButton = BoardCellButton(type: .custom)
                cellButton.translatesAutoresizingMaskIntoConstraints = false
                cellButton.setTitle(cellTitle, for: .normal)
                cellButton.addTarget(self, action: #selector(BoardView.cellButtonPressed(_:)), for: .touchUpInside)
                cellButton.column = columnIndex
                cellButton.row = rowIndex
                addSubview(cellButton)
                
                cellButton.heightAnchor.constraint(equalToConstant: boardSquareSize).isActive = true
                cellButton.widthAnchor.constraint(equalToConstant: boardSquareSize).isActive = true
                cellButton.leftAnchor.constraint(equalTo: leftAnchor, constant: (boardSquareSize * CGFloat(columnIndex))).isActive = true
                cellButton.topAnchor.constraint(equalTo: topAnchor, constant: (boardSquareSize * CGFloat(rowIndex))).isActive = true
            }
        }
    }
    
    func cellButtonPressed(_ button: BoardCellButton) {
        guard let column = button.column, let row = button.row else {
            return
        }
        
        delegate.boardView(self, selectedSquareAtColumn: column, row: row)
    }

}

class BoardCellButton: UIButton {
    var column: Int?
    var row: Int?
}
