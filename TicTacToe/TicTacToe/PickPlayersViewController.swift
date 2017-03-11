//
//  PickPlayersViewController.swift
//  TicTacToe
//
//  Created by Gabe Shahbazian on 3/6/17.
//  Copyright © 2017 gabeshahbazian. All rights reserved.
//

import UIKit

class PickPlayersViewController: UINavigationController {

    let playersPicked: (_ xPlayer: Player, _ oPlayer: Player) -> ()

    init(playersPickedHandler: @escaping (_ xPlayer: Player, _ oPlayer: Player) -> ()) {
        playersPicked = playersPickedHandler

        let pickXorOViewController = PickXorOViewController()
        super.init(rootViewController: pickXorOViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

private class PickXorOViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Pick Your Piece"

        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0).isActive = true
    }
}
