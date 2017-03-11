//
//  MainViewController.swift
//  TicTacToe
//
//  Created by Gabe Shahbazian on 3/6/17.
//  Copyright © 2017 gabeshahbazian. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var currentGameViewController: GameViewController? {
        didSet {
            // GABE: add vc to board
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if currentGameViewController == nil {
            createPlayersForNewGame()
        }
    }

    func createPlayersForNewGame() {
        let pickPlayersViewController = PickPlayersViewController(playersPickedHandler: { (xPlayer: Player, oPlayer: Player) -> () in

        })
        present(pickPlayersViewController, animated: true)
    }
}
