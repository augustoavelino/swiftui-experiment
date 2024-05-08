//
//  JankenponAudioService.swift
//  swiftui-experiment
//
//  Created by Augusto Avelino on 08/05/24.
//

import AVFoundation
import Foundation

class JankenponAudioService {
    
    private let fadeDuration: TimeInterval = 1.5
    
    private let session = AVAudioSession.sharedInstance()
    
    /// Loops the background soundtrack
    private var trackPlayer: AVAudioPlayer?
    
    /// Plays the sound effects
    private var sfxPlayer: AVAudioPlayer?
    
    init() {
        prepareSession()
        prepareSoundtrack()
    }
    
    private func prepareSession() {
        do {
            try session.setCategory(.playback)
        } catch {
            debugPrint(error)
        }
    }
    
    private func prepareSoundtrack() {
        guard let soundURL = Bundle.main.url(forResource: "janken-jam", withExtension: "mp3") else { return }
        
        do {
            trackPlayer = try AVAudioPlayer(contentsOf: soundURL)
            trackPlayer?.setLoop(.untilStopped)
            trackPlayer?.setVolume(0.0, fadeDuration: 0.0)
        } catch {
            debugPrint(error)
        }
        
        trackPlayer?.prepareToPlay()
    }
    
    func startBackgroundSoundtrack() {
        trackPlayer?.play()
        trackPlayer?.setVolume(1.0, fadeDuration: fadeDuration)
    }
    
    func stopBackgroundSoundtrack() {
        trackPlayer?.setVolume(0.0, fadeDuration: fadeDuration)
        DispatchQueue.main.asyncAfter(deadline: .now() + fadeDuration) { [weak self] in
            guard let self = self else { return }
            self.trackPlayer?.stop()
        }
    }
    
    func playSFX(_ outcome: OutcomeSFX) {
        guard let soundURL = Bundle.main.url(forResource: outcome.rawValue, withExtension: "wav") else { return }
        
        do {
            sfxPlayer = try AVAudioPlayer(contentsOf: soundURL)
        } catch {
            debugPrint(error)
        }
        
        sfxPlayer?.play()
    }
}

// MARK: - SFX

extension JankenponAudioService {
    enum OutcomeSFX: String {
        case draw = "draw-effect"
        case win = "win-effect"
        case lose = "lose-effect"
    }
}
