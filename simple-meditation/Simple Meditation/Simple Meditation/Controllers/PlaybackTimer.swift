//
//  PlaybackTimer.swift
//  Simple Meditation
//
//  Created by dev on 05.05.2026.
//

import Foundation

class AudioTimer {
    private var timer: Timer?
    
    var onTick: ((Float,TimeInterval) -> Void)?
    
    // start timer
    func startTimer(totalDuration: TimeInterval, currentTime: @escaping () -> TimeInterval) {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            
            // Check if VC is alife, otherwise exit. For [weak self]
            guard let self = self else { return }
            
            // assign current track play time to currentTime
            let currentTime = currentTime()
            
            // save progress
            let progress = Float(currentTime / totalDuration)
            
            // show remaining Time in a duration label
            let remainingTime = totalDuration - currentTime
            
            self.onTick?(progress, remainingTime)
        }
        timer?.fire()
    }
    
    // stopm timer
    func stopTimer() {
        timer?.invalidate()
    }

}
