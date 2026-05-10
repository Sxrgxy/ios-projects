//
//  FormatTime.swift
//  Simple Meditation
//
//  Created by dev on 25.11.2025.
//

import Foundation

extension TimeInterval {
    func formatAsMinutesSeconds() -> String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
