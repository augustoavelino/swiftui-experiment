//
//  JankenponView.swift
//  swiftui-experiment
//
//  Created by Augusto Avelino on 12/04/24.
//

import AVFoundation
import SwiftUI

struct JankenponView: View {
    @State private var jankenpon: Jankenpon = Jankenpon(playerOne: .rock, playerTwo: .rock)
    @State var currentOption: Jankenpon.Option = .rock
    @State private var shouldDisplayPlayerTwo = false
    @State private var shouldAnnounceOutcome = false
    @State private var isCountingDown = false
    @State private var isPresentingPeerList = false
    
    @State private var audioPlayer: AVAudioPlayer?
    
    @EnvironmentObject var connection: JankenponConnection
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0.0) {
                    VStack {
                        if shouldDisplayPlayerTwo {
                            JankenponOptionView(option: jankenpon.playerTwo)
                                .rotationEffect(Angle(radians: .pi))
                                .scaleEffect(scaleForOutcome(player: .playerTwo), anchor: .top)
                        } else {
                            hiddenPlayerTwoView
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(red: 0.91, green: 0.76, blue: 0.41))
                    VStack {
                        JankenponSelectionView(currentOption: $currentOption)
                            .frame(maxHeight: .infinity)
                            .padding(.top, 36)
                            .scaleEffect(scaleForOutcome(player: .playerOne), anchor: .bottom)
                            .scrollDisabled(isCountingDown || shouldDisplayPlayerTwo)
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
            .toolbar {
                Button(action: { isPresentingPeerList = true }) {
                    Image(systemName: "list.bullet")
                }
            }
            .onChange(of: currentOption) {
                withAnimation {
                    jankenpon.playerOne = currentOption
                }
            }
            .onChange(of: shouldDisplayPlayerTwo) {
                guard shouldDisplayPlayerTwo else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    announceOutcome()
                }
            }
            .popover(isPresented: $isPresentingPeerList) {
                NavigationStack {
                    JankenponLobbyView()
                        .environmentObject(connection)
                }
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
    
    @ViewBuilder
    private var hiddenPlayerTwoView: some View {
        ZStack {
            Text("☁️")
                .font(.system(size: 280))
            Image(systemName: "questionmark")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(Color(red: 0.9, green: 0.43, blue: 0.31))
        }
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
            shouldAnnounceOutcome = false
        }
    }
    
    private func revealPlayerTwo() {
        withAnimation {
            isCountingDown = false
            shouldDisplayPlayerTwo = true
        }
    }
    
    private func announceOutcome() {
        playSound()
        withAnimation {
            shouldAnnounceOutcome = true
        }
    }
    
    private func soundForOutcome() -> String {
        let outcome = jankenpon.outcome()
        return switch outcome {
        case .draw: "draw-effect"
        case .playerOne: "win-effect"
        case .playerTwo: "lose-effect"
        }
    }
    
    private func playSound() {
        guard let soundURL = Bundle.main.url(forResource: soundForOutcome(), withExtension: "wav") else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
        } catch {
            debugPrint(error)
        }
        
        audioPlayer?.play()
    }
    
    private func scaleForOutcome(player: Jankenpon.Outcome) -> CGFloat {
        shouldScale(player: player) ? 1.5 : 1.0
    }
    
    private func shouldScale(player: Jankenpon.Outcome) -> Bool {
        (shouldAnnounceOutcome && jankenpon.outcome() == player)
    }
}

#Preview {
    JankenponView()
        .environmentObject(JankenponConnection())
}
