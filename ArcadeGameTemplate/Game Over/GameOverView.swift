//
//  GameOverView.swift
//  ArcadeGameTemplate
//

import SwiftUI

/**
 * # GameOverView
 *   This view is responsible for showing the game over state of the game.
 *  Currently it only present buttons to take the player back to the main screen or restart the game.
 *
 *  You can also present score of the player, present any kind of achievements or rewards the player
 *  might have accomplished during the game session, etc...
 **/

struct GameOverView: View {
    
    @Binding var currentGameState: GameState
    
    var body: some View {
        ZStack{
            Color.black
            .ignoresSafeArea()
            VStack {
                Spacer()
                
                Image("GameOver")
                
                Spacer()
                
                HStack {
                    Spacer()
                    Button {
                        withAnimation { self.backToMainScreen() }
                    } label: {
                        Image("back")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation { self.restartGame() }
                    } label: {
                        Image("home")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                    }
                    
                    Spacer()
                }
                Spacer()
            }
        }
    }
    
    private func backToMainScreen() {
        self.currentGameState = .mainScreen
    }
    
    private func restartGame() {
        self.currentGameState = .playing
    }
}
