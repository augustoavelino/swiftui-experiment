//
//  JankenponView.swift
//  swiftui-experiment
//
//  Created by Augusto Avelino on 12/04/24.
//

import AVFoundation
import SwiftUI

struct JankenponView: View {
    @EnvironmentObject var connection: JankenponConnection
    
    @State private var jankenpon: Jankenpon = Jankenpon(playerOne: .rock, playerTwo: .rock)
    @State private var isCountingDown = false
    @State private var isDisplayingPlayerTwo = false
    @State private var isAnnouncingOutcome = false
    @State private var isPresentingPeerList = false
    
    private let audioService = JankenponAudioService()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0.0) {
                    VStack {
                        if isDisplayingPlayerTwo {
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
                        JankenponSelectionView(currentOption: $jankenpon.playerOne)
                            .frame(maxHeight: .infinity)
                            .padding(.top, 36)
                            .scaleEffect(scaleForOutcome(player: .playerOne), anchor: .bottom)
                            .scrollDisabled(isCountingDown || isDisplayingPlayerTwo)
                        if isDisplayingPlayerTwo || isCountingDown {
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
                .buttonStyle(ShrinkingButtonStyle(.small, backgroundColor: connection.isPaired ? .green : .blue))
            }
            .onChange(of: isDisplayingPlayerTwo) {
                guard isDisplayingPlayerTwo else { return }
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
            .onAppear {
                audioService.startBackgroundSoundtrack()
            }
            .onDisappear {
                audioService.stopBackgroundSoundtrack()
            }
        }
    }
    
    @ViewBuilder
    private var countdownView: some View {
        JankenponCountdownView(shouldStart: $isCountingDown) {
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
        if connection.isPaired, let opponentOption = connection.opponentOption {
            return opponentOption
        }
        var options = Jankenpon.Option.allCases.shuffled()
        return options.removeLast()
    }
    
    private func confirmSelection() {
        if connection.isPaired {
            connection.sendOption(jankenpon.playerOne)
        } else {
            isCountingDown = true
        }
    }
    
    private func resetPlayerTwo() {
        withAnimation {
            isCountingDown = false
            isDisplayingPlayerTwo = false
            isAnnouncingOutcome = false
        }
    }
    
    private func revealPlayerTwo() {
        jankenpon.playerTwo = getPlayerTwoShot()
        withAnimation {
            isCountingDown = false
            isDisplayingPlayerTwo = true
        }
    }
    
    private func announceOutcome() {
        playSFX()
        withAnimation {
            isAnnouncingOutcome = true
        }
    }
    
    private func playSFX() {
        return switch jankenpon.outcome() {
        case .draw: audioService.playSFX(.draw)
        case .playerOne: audioService.playSFX(.win)
        case .playerTwo: audioService.playSFX(.lose)
        }
    }
    
    private func scaleForOutcome(player: Jankenpon.Outcome) -> CGFloat {
        shouldScale(player: player) ? 1.5 : 1.0
    }
    
    private func shouldScale(player: Jankenpon.Outcome) -> Bool {
        let outcome = jankenpon.outcome()
        return (isAnnouncingOutcome && (outcome == player || outcome == .draw))
    }
}

#Preview {
    JankenponView()
        .environmentObject(JankenponConnection())
}
