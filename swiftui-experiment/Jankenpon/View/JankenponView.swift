//
//  JankenponView.swift
//  swiftui-experiment
//
//  Created by Augusto Avelino on 12/04/24.
//

import SwiftUI

struct JankenponView: View {
    @State private var jankenpon: Jankenpon = Jankenpon(playerOne: .rock, playerTwo: .rock)
    @State var currentOption: Jankenpon.Option = .rock
    @State private var shouldDisplayPlayerTwo = false
    @State private var isCountingDown = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0.0) {
                VStack {
                    if shouldDisplayPlayerTwo {
                        JankenponOptionView(option: jankenpon.playerTwo)
                            .scaleEffect(jankenpon.outcome() == .playerTwo ? 1.5 : 1.0)
                    } else {
                        Image(systemName: "questionmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundStyle(Color(red: 0.9, green: 0.43, blue: 0.31))
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 0.91, green: 0.76, blue: 0.41))
                VStack {
                    JankenponSelectionView(currentOption: $currentOption)
                        .frame(maxHeight: .infinity)
                        .padding(.top, 36)
                        .scaleEffect((shouldDisplayPlayerTwo && jankenpon.outcome() == .playerOne) ? 1.5 : 1.0)
                    if shouldDisplayPlayerTwo || isCountingDown {
                        Button(action: resetPlayerTwo) {
                            Text("Reset")
                        }
                        .buttonStyle(ShrinkingButtonStyle(backgroundColor: Color(red: 0.91, green: 0.76, blue: 0.41)))
                        .buttonBorderShape(.capsule)
                    } else {
                        Button(action: confirmSelection) {
                            Text("Select")
                        }
                        .buttonStyle(ShrinkingButtonStyle(backgroundColor: Color(red: 0.16, green: 0.61, blue: 0.56)))
                        .buttonBorderShape(.capsule)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 0.15, green: 0.27, blue: 0.32))
            }
            countdownView
        }
        .onChange(of: currentOption) {
            withAnimation {
                jankenpon.playerOne = currentOption
            }
        }
    }
    
    @ViewBuilder
    private var countdownView: some View {
        JankenponCountdownView(shouldStart: $isCountingDown) {
            jankenpon.playerTwo = getPlayerTwoShot()
            revealPlayerTwo()
        }
        .foregroundStyle(.white)
    }
    
    private func getPlayerTwoShot() -> Jankenpon.Option {
        var options = Jankenpon.Option.allCases.shuffled()
        return options.removeLast()
    }
    
    private func confirmSelection() {
        isCountingDown = true
    }
    
    private func resetPlayerTwo() {
        withAnimation {
            isCountingDown = false
            shouldDisplayPlayerTwo = false
        }
    }
    
    private func revealPlayerTwo() {
        withAnimation {
            isCountingDown = false
            shouldDisplayPlayerTwo = true
        }
    }
}

#Preview {
    JankenponView()
}
