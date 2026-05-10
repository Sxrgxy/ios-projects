//
//  Constants.swift
//  Simple Meditation
//
//  Created by dev on 09.11.2025.
//

import UIKit

enum Colours {
    static let darkColor = UIColor(red: 0x13/255, green: 0x13/255, blue: 0x13/255, alpha: 1.0)
    static let trackColor = UIColor(red: 0x77/255, green: 0x77/255, blue: 0x77/255, alpha: 1.0)
    static let backgroundColor = UIColor(red: 0xe4/255, green: 0xe4/255, blue: 0xe4/255, alpha: 1.0)
}

enum SegueIdentifier {
    static let showPlayer = "ShowPlayer"
}

enum API {
    static let meditationsURL = "https://raw.githubusercontent.com/Sxrgxy/ios-projects/main/simple-meditation/meditations.json"
}
