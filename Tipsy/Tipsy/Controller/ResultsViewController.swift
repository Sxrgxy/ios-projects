//
//  ResultsViewController.swift
//  Tipsy
//
//  Created by dev on 19.07.2025.
//  Copyright © 2025 The App Brewery. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var totalLabel: UILabel!
    var splitPayment: Float = 0.0
    
    @IBOutlet weak var settingsLabel: UILabel!
    var suggestionText: String = ""
    
    @IBAction func recalcultePressed(_ sender: UIButton) {
        //add dismiss
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalLabel.text = String(format: "%.2f", splitPayment)
        settingsLabel.text = suggestionText
    }
    
}
