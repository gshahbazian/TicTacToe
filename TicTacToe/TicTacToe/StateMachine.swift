//
//  StateMachine.swift
//  TicTacToe
//
//  Created by Gabe Shahbazian on 12/28/15.
//  Copyright © 2015 gabeshahbazian. All rights reserved.
//

import Foundation

protocol State {
    func shouldTransition(toState: Self) -> Bool
}

/// Swift fsm altered from https://gist.github.com/jemmons/f30f1de292751da0f1b7
class StateMachine<T: State> {
    typealias TransitionObservation = ((from: T, to: T) -> ())
    
    private var _state: T
    var state: T {
        get {
            return _state
        }
        set {
            guard state.shouldTransition(newValue) else {
                return
            }
            
            let oldValue = _state
            _state = newValue
            transitionObservation?(from: oldValue, to: newValue)
        }
    }
    
    var transitionObservation: TransitionObservation?
    
    init(initialState: T, observer: TransitionObservation? = nil) {
        _state = initialState
        transitionObservation = observer
    }
    
}
