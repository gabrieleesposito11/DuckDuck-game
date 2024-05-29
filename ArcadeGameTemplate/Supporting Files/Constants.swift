//
//  Constants.swift
//  ArcadeGameTemplate
//

import Foundation
import SwiftUI

/**
 * # Constants
 *
 * This file gathers contant values that are shared all around the project.
 * Modifying the values of these constants will reflect along the complete interface of the application.
 *
 **/


/**
 * # GameState
 * Defines the different states of the game.
 * Used for supporting the navigation in the project template.
 */

enum GameState {
    case mainScreen
    case playing
    case gameOver
}

typealias Instruction = (icon: String, title: String, description: String)

/**
 * # MainScreenProperties
 *
 * Keeps the information that shows up on the main screen of the game.
 *
 */

struct MainScreenProperties {
    static let gameTitle: String = "DUCK DASH"
    
    static let gameInstructions: [Instruction] = [
        (icon: "hand.tap", title: "Drag to Move", description: "Drag on the left and right of the screen to activate the Duck."),
        (icon: "dollarsign.circle", title: "Catch the coins", description: "collect as many coins as you can."),
        (icon: "multiply.circle", title: "Don't hit the obstacles!", description: "If one of cars hits you lose!")
    ]
    
    /**
     * To change the Accent Color of the applciation edit it on the Assets folder.
     */
    
    static let accentColor: Color = Color.accentColor
}
