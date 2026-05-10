//
//  MeditationDataSource.swift
//  Simple Meditation
//
//  Created by dev on 21.09.2025.
//

import Foundation

struct MeditationDataSource {
    static let meditations = [
        Meditation(
            id: "1",
            title: "Breath Basics",
            audioFileName: "Breath Basics voice",
            imageName: "wind",
        ),
        Meditation(
            id: "2",
            title: "Body Scan",
            audioFileName: "Body Scan voice",
            imageName: "dot.radiowaves.left.and.right",
        ),
        Meditation(
            id: "3",
            title: "Noticing Thoughts",
            audioFileName: "Noticing Thoughts voice",
            imageName: "cloud",
        ),
        Meditation(
            id: "4",
            title: "Name Your Emotions",
            audioFileName: "Name Your Emotions voice",
            imageName: "sparkles",
        ),
        Meditation(
            id: "5",
            title: "Loving-Kindness",
            audioFileName: "Loving-Kindness voice",
            imageName: "sun.max",
        ),
        Meditation(
            id: "6",
            title: "Open Awareness",
            audioFileName: "Open Awareness voice",
            imageName: "water.waves",
        ),
        Meditation(
            id: "7",
            title: "Quiet Time",
            audioFileName: "Quiet Time voice",
            imageName: "waveform",
        )
    ]
}
