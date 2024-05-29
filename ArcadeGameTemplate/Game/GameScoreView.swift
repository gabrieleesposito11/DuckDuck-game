//
//  GameScoreView.swift
//  ArcadeGameTemplate
//

import SwiftUI

/**
 * # GameScoreView
 * Custom UI to present how many points the player has scored.
 *
 * Customize it to match the visual identity of your game.
 */

struct GameScoreView: View {
    @Binding var time: TimeInterval
    @Binding var score: Int
    
    var body: some View {
        HStack {
            Image("Hourglass")
                .resizable()
                .frame(width:40, height:40)
            Text("\(Int(time))")
            Spacer()
            Image("coin1")
                .resizable()
                .frame(width:40, height:40)
            Text("\(score)")
        }
        .bold()
        .font(.largeTitle)
        .foregroundColor(.white)
        .safeAreaPadding()
    }
}
        




#Preview {
    GameScoreView(time: .constant(1000), score: .constant(100))
        .previewLayout(.fixed(width: 300, height: 100))
}
