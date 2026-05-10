//
//  PlayerViewController.swift
//  Simple Meditation
//
//  Created by dev on 23.09.2025.
//

import UIKit
import AVFoundation
import MediaPlayer

class PlayerViewController: UIViewController {

    var meditation: Meditation?
    private let audioPlayer = AudioPlayer()
    private let rippleAnimator = RippleAnimator()
    
    private enum PlaybackState {
        case playing
        case paused
    }
    
    //var timer: Timer?
    private let playbackTimer = AudioTimer()
    let hapticGenerator = UIImpactFeedbackGenerator(style: .soft)
    
    // slider value change state
    var isUserSeeking = false
    
    // playing audio information
    var nowPlayingInfo = [String: Any]()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var sliderBar: UISlider!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        //get back to a first screen
        dismiss(animated: true)
        audioPlayer.stop()
        
        // stop animation
        rippleAnimator.stop()
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        hapticGenerator.impactOccurred()
        
        // stop animation
        rippleAnimator.stop()
        
        audioPlayer.stop()
        
        playbackTimer.stopTimer()
        // set up progress bar as 0
        sliderBar.value = 0.0
        
        // configurate buttons
        applyState(.playing)
        
        playMeditation()
        
        // start animation
        rippleAnimator.start(on: view)
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        hapticGenerator.impactOccurred()
        
        // configurate buttons
        applyState(.playing)
        
        audioPlayer.play()
        
        // start animation
        rippleAnimator.start(on: view)
        // start timer
        // передаёт функцию которая будет вызываться каждую секунду
        playbackTimer.startTimer(totalDuration: audioPlayer.duration) {
            self.audioPlayer.currentTime
        }
    }
    
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        hapticGenerator.impactOccurred()
        
        // configurate buttons
        applyState(.paused)
        
        audioPlayer.pause()
        
        playbackTimer.stopTimer()
        
        // stop animation
        rippleAnimator.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start animation
        rippleAnimator.start(on: view)
        
        hapticGenerator.prepare()
        
        // prepare UI
        setupLabels()
        setupButtons()
        setupSlider()
        
        // when meditaion is finished, and reset button state to play shown
        // where can I find meditaion ending and how would affect?
        audioPlayer.onFinish = { [weak self] in
            // reset start page upon audio end on the main Thread
            DispatchQueue.main.async {
                self?.resetVC()
            }
        }
        
        // Pass function of resetting sliderBar and durationLabel values to a playbackTimer.onTick closure
        playbackTimer.onTick = { [weak self] progress, remainingTime in
            if self?.isUserSeeking == false {
                self?.sliderBar.value = progress
            }
            self?.durationLabel.text = remainingTime.formatAsMinutesSeconds()
            
            // set current time to a widget
            self?.nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self?.audioPlayer.currentTime
            
            // assign mediation properties to a swift audio widget options
            MPNowPlayingInfoCenter.default().nowPlayingInfo = self?.nowPlayingInfo
        }
        
        self.playMeditation()
        
        // register commands from a widget
        setupRemoteCommands()
        
    }
    
    private func applyState(_ state: PlaybackState) {
        switch state {
        case .playing:
            pauseButton.isHidden = false
            playButton.isHidden = true
        case .paused:
            pauseButton.isHidden = true
            playButton.isHidden = false
        }
    }
    
    //
    private func setupLabels() {
        // Label settins
        titleLabel.font = UIFont.systemFont(ofSize: 40, weight: .regular)
        titleLabel.textColor = Colours.darkColor
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        titleLabel.text = meditation?.title
        
        // assign meditation title to a widget
        nowPlayingInfo[MPMediaItemPropertyTitle] = meditation?.title
        
        durationLabel.text = meditation?.durationFormatted
        durationLabel.textColor = Colours.darkColor
        
    }
    
    private func setupButtons() {
        
        backButton.setTitle("", for: .normal)
        backButton.tintColor = Colours.darkColor
        
        playButton.isHidden = true
        playButton.alpha = 0.85
        playButton.tintColor = Colours.darkColor
        
        pauseButton.alpha = 0.85
        pauseButton.tintColor = Colours.darkColor
        
        restartButton.tintColor = Colours.darkColor
    }
    
    private func setupSlider() {
        
//        let thumbImage = UIImage()
//        sliderBar.setThumbImage(thumbImage, for: .normal)
//        sliderBar.setThumbImage(UIImage(), for: .normal)
        let dotSize: CGFloat = 12
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: dotSize, height: dotSize))
        let dotImage = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1).cgColor)
            ctx.cgContext.fillEllipse(in: CGRect(x: 0, y: 0, width: dotSize, height: dotSize))
        }
        sliderBar.setThumbImage(dotImage, for: .normal)
        sliderBar.setThumbImage(dotImage, for: .highlighted)
        sliderBar.minimumTrackTintColor = UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 0.8)
        sliderBar.maximumTrackTintColor = UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 0.2)
        
        // slider settings
        sliderBar.minimumValue = 0.0
        sliderBar.maximumValue = 1.0
        sliderBar.value = 0.0 // progress
        
//        sliderBar.thumbTintColor = UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1)
        
//        sliderBar.minimumTrackTintColor = Colours.trackColor
//        sliderBar.maximumTrackTintColor = Colours.backgroundColor
//        
        sliderBar.alpha = 0.85
        
        sliderBar.isUserInteractionEnabled = true
        // listen for slider bar changes
        sliderBar.addTarget(self, action: #selector(applySliderValue), for: .valueChanged)
        sliderBar.addTarget(self, action: #selector(sliderTouchDown), for: .touchDown)
        sliderBar.addTarget(self, action: #selector(sliderTouchUp), for: [.touchUpInside, .touchUpOutside])
        
        sliderBar.layer.cornerRadius = 2
    }
    
    // switching track current point and changing timer value accordingly
    @objc func applySliderValue(_ sender: UISlider) {
        //timer?.invalidate()
        
        // move audio current time based on a slider value
        audioPlayer.seek(to: sender.value)
        
        // set new durationLabel value
        let remainingTime = audioPlayer.duration - audioPlayer.currentTime // Player
        // format from minutes to seconds
        let formattedTime = remainingTime.formatAsMinutesSeconds()
        
        self.durationLabel.text = formattedTime
        
    }
    
    @objc func sliderTouchDown(_ sender: UISlider) {
        isUserSeeking = true
    }
    
    // finish using slider upd state
    @objc func sliderTouchUp(_ sender: UISlider) {
        isUserSeeking = false
    }
    
    // plays an mp3
    func playMeditation() {
        //
        playbackTimer.stopTimer()
        
        //
        sliderBar.value = 0.0
        
        guard let fileName = meditation?.audioFileName else { return }
        
        audioPlayer.load(fileName: fileName)
        
        playbackTimer.startTimer(totalDuration: audioPlayer.duration) {
            self.audioPlayer.currentTime
        }
        
        // set current time to a widget
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.audioPlayer.currentTime
        // set audio duration
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = meditation?.durationInSeconds
        
        // assign mediation properties to a swift audio widget options
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
        //let playTime = player!.deviceCurrentTime + 0.1
        audioPlayer.play()
    }
        
    private func resetVC() {
        playbackTimer.stopTimer()
        
        // Show play button, hide pause button
        applyState(.paused)
        
        // Stop animation
        rippleAnimator.stop()
        
        // Reset slider to beginning
        self.sliderBar.value = 0.0
        
        // Reset duration label to show full duration
        self.durationLabel.text = meditation?.durationFormatted
    }
    
    func setupRemoteCommands() {
        let commandCenter = MPRemoteCommandCenter.shared()
        // 1. Configure Play/Pause Commands
        commandCenter.playCommand.addTarget(handler: { [weak self] _ in
            self?.applyState(.playing)
            self?.audioPlayer.play()
            
            // stop animation
            self?.rippleAnimator.start(on: self?.view ?? UIView())
            
            // start timer
            // передаёт функцию которая будет вызываться каждую секунду
            self?.playbackTimer.startTimer(totalDuration: self?.audioPlayer.duration ?? 0) {
                self?.audioPlayer.currentTime ?? 0
            }
            return .success
            }
        )
        
        commandCenter.pauseCommand.addTarget(handler: { [weak self] _ in
            self?.applyState(.paused)
            self?.audioPlayer.pause()
            
            self?.playbackTimer.stopTimer()
            
            // stop animation
            self?.rippleAnimator.stop()
            return .success
            }
        )
    }
}

