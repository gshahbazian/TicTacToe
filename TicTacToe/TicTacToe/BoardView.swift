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
    func boardView(boardView: BoardView, selectedSquareAtColumn column: Int, row: Int)
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
    
    override func intrinsicContentSize() -> CGSize {
        let dimension = boardSquareSize * CGFloat(board.board.count)
        return CGSizeMake(dimension, dimension)
    }
    
    private func drawSquares() {
        for rowIndex in 0..<board.board.count {
            for columnIndex in 0..<board.board[rowIndex].count {
                let space = board.board[rowIndex][columnIndex]

                var cellTitle = "_"
                switch space.piece {
                case .Some(.XPiece):
                    cellTitle = "X"
                case .Some(.OPiece):
                    cellTitle = "O"
                default: break
                }
                
                let cellButton = BoardCellButton(type: .Custom)
                cellButton.translatesAutoresizingMaskIntoConstraints = false
                cellButton.setTitle(cellTitle, forState: .Normal)
                cellButton.addTarget(self, action: "cellButtonPressed:", forControlEvents: .TouchUpInside)
                cellButton.column = columnIndex
                cellButton.row = rowIndex
                addSubview(cellButton)
                
                cellButton.heightAnchor.constraintEqualToConstant(boardSquareSize).active = true
                cellButton.widthAnchor.constraintEqualToConstant(boardSquareSize).active = true
                cellButton.leftAnchor.constraintEqualToAnchor(leftAnchor, constant: (boardSquareSize * CGFloat(columnIndex))).active = true
                cellButton.topAnchor.constraintEqualToAnchor(topAnchor, constant: (boardSquareSize * CGFloat(rowIndex))).active = true
            }
        }
    }
    
    func cellButtonPressed(button: BoardCellButton) {
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
