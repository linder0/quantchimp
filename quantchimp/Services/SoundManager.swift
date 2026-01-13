//
//  SoundManager.swift
//  quantchimp
//
//  Centralized sound manager for audio feedback
//

import AVFoundation
import AudioToolbox

/// Centralized sound manager for consistent audio feedback
final class SoundManager {
    static let shared = SoundManager()

    private var audioPlayer: AVAudioPlayer?
    private var soundsEnabled: Bool = true

    private init() {
        // Configure audio session for mixing with other audio
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }

    /// Update sound enabled state (call from AppState)
    func setSoundsEnabled(_ enabled: Bool) {
        soundsEnabled = enabled
    }

    // MARK: - Game Sounds

    /// Play success sound - correct answer
    func playSuccess() {
        guard soundsEnabled else { return }
        AudioServicesPlaySystemSound(1057) // Tink sound
    }

    /// Play error sound - incorrect answer
    func playError() {
        guard soundsEnabled else { return }
        AudioServicesPlaySystemSound(1053) // Error sound
    }

    /// Play tap sound - button press
    func playTap() {
        guard soundsEnabled else { return }
        AudioServicesPlaySystemSound(1104) // Light tap
    }

    /// Play celebration sound - level up, streak, achievement
    func playCelebration() {
        guard soundsEnabled else { return }
        AudioServicesPlaySystemSound(1025) // Fanfare-like sound
    }

    /// Play countdown tick - timer warnings
    func playTick() {
        guard soundsEnabled else { return }
        AudioServicesPlaySystemSound(1103) // Tick sound
    }

    /// Play game over sound - sprint ends
    func playGameOver() {
        guard soundsEnabled else { return }
        AudioServicesPlaySystemSound(1050) // Completion sound
    }

    /// Play start sound - game begins
    func playStart() {
        guard soundsEnabled else { return }
        AudioServicesPlaySystemSound(1113) // Begin sound
    }

    /// Play selection sound - option selected
    func playSelect() {
        guard soundsEnabled else { return }
        AudioServicesPlaySystemSound(1156) // Pop sound
    }
}

// MARK: - Convenience Global Functions

/// Quick access to sound manager
enum Sound {
    /// Correct answer sound
    static func success() {
        SoundManager.shared.playSuccess()
    }

    /// Incorrect answer sound
    static func error() {
        SoundManager.shared.playError()
    }

    /// Button tap sound
    static func tap() {
        SoundManager.shared.playTap()
    }

    /// Achievement/celebration sound
    static func celebration() {
        SoundManager.shared.playCelebration()
    }

    /// Timer tick sound
    static func tick() {
        SoundManager.shared.playTick()
    }

    /// Game over sound
    static func gameOver() {
        SoundManager.shared.playGameOver()
    }

    /// Game start sound
    static func start() {
        SoundManager.shared.playStart()
    }

    /// Selection changed sound
    static func select() {
        SoundManager.shared.playSelect()
    }
}

