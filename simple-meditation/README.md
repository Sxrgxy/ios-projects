# Simple Meditation

iOS meditation app featuring guided audio sessions with REST API integration.

## Tech Stack

**Core:** Swift 5, UIKit, AVFoundation  
**Networking:** URLSession, Codable (JSON)  
**Architecture:** MVC + Service Layer

## Features

- REST API integration with offline fallback
- Audio playback with real-time progress tracking
- Custom animations (ripple effects, haptic feedback)
- Error handling and graceful degradation

## Architecture Highlights

**Separation of Concerns**
- `AudioPlayer` — Encapsulates AVAudioPlayer logic
- `RippleAnimator` — Manages visual effects
- `TimeInterval` extension — Reusable time formatting

**Memory Safety**
- `[weak self]` in closures to prevent retain cycles
- Proper timer management and resource cleanup

**API Endpoint**
```
https://raw.githubusercontent.com/Sxrgxy/ios-projects/main/simple-meditation/meditations.json
```

## Requirements

iOS 14.0+ • Xcode 13.0+

---