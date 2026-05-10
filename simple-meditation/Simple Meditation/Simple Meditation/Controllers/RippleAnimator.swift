//
//  RippleAnimator.swift
//  Simple Meditation
//
//  Created by dev on 26.11.2025.
//

import UIKit

class RippleAnimator {
    private weak var view: UIView?
    private var isAnimating = false

    // create 3 ripples with 2 seconds interval between each
    func start(on view: UIView) {
        self.view = view
        isAnimating = true
        
        for i in 0..<3 {
            scheduleRipple(delay: Double(i) * 2.0, index: i)
        }
    }

    // stop existing animation and remove all circles from view
    func stop() {
        isAnimating = false
        view?.subviews
            .filter { $0.tag == 999 }
            .forEach { $0.removeFromSuperview() }
    }

    // schedule next ripple after delay — each circle restarts only itself
    private func scheduleRipple(delay: Double, index: Int) {
        guard isAnimating, let view = view else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.ripple(on: view, index: index)
        }
    }

    // animation — runs once, then reschedules itself every 6 seconds via completion handler
    private func ripple(on view: UIView, index: Int) {
        guard isAnimating else { return }
        
        // circle settings
        let circle = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        circle.tag = 999
        circle.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        circle.layer.cornerRadius = 20
        circle.backgroundColor = UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 0.06)
        //UIColor(red: 0.85, green: 0.8, blue: 0.75, alpha: 0.25)
        view.addSubview(circle)
        
        // circle animation settings
        UIView.animate(withDuration: 4, animations: {
            circle.transform = CGAffineTransform(scaleX: 8, y: 8) // circle scales to 8x of its size
            circle.alpha = 0 // circle color fades
        }) { [weak self] _ in // completion handler which runs after 4 secs
            circle.removeFromSuperview()
            // each circle restarts itself after 6 seconds
            self?.scheduleRipple(delay: 2.0, index: index)
        }
    }
}
