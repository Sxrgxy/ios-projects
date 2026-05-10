//
//  AudioPlayer.swift
//  Simple Meditation
//
//  Created by dev on 26.11.2025.
//

import Foundation
import AVFoundation

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    private var player: AVAudioPlayer?
    
    // empty closure
    var onFinish: (() -> Void)?

    var duration: TimeInterval {
        return player?.duration ?? 0
    }
    
    var currentTime: TimeInterval {
        return player?.currentTime ?? 0
    }
    
    
    // load track
    func load(fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self // assigning a VC in which Player class was inited as a delegate
            player?.prepareToPlay()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    // Delegate function which checks if audio has been finished
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // call an empty closure inside VC
        onFinish?()
    }
    
    // play
    func play() {
        player?.play()
    }
    
    // stop
    func stop() {
        player?.stop()
    }
    
    // pause
    func pause() {
        player?.pause()
    }
    
    func seek(to progress: Float) {
        guard let player = player else { return }
        player.currentTime = TimeInterval(progress) * player.duration
    }
    
}
