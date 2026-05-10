//
//  Meditation.swift
//  Simple Meditation
//
//  Created by dev on 21.09.2025.
//

import Foundation
import AVFoundation

struct Meditation: Codable {
    let id: String
    let title: String
    let audioFileName: String
    let imageName: String
    
    var durationInSeconds: TimeInterval {
        let url = Bundle.main.url(forResource: audioFileName, withExtension: "mp3")!
        
        do {
            return try AVAudioPlayer(contentsOf: url).duration
        } catch {
            print("Error reading duration for \(title): \(error)")
            return 0
        }
    }
    
    var durationFormatted: String {
        return durationInSeconds.formatAsMinutesSeconds()
    }
}

struct MeditationsResponse: Codable {
    let meditations: [Meditation]
}
