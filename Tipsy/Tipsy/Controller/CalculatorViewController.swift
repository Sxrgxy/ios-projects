//
//  ViewController.swift
//  Tipsy
//
//  Created by Angela Yu on 09/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var zeroPctButton: UIButton!
    @IBOutlet weak var tenPctButton: UIButton!
    @IBOutlet weak var twentyPctButton: UIButton!
    @IBOutlet weak var splitNumberLabel: UILabel!
    
    //I should figure out how much tip to apply
    var tipAmount: Float = 0.1
    var splitNumber: Float = 0.0
    var totalBill: Float = 0.0
    var splitPayment: Float = 0.0
    
    @IBAction func tipChanged(_ sender: UIButton) {
        let tipLabel = sender.titleLabel!.text
        
        if tipLabel == "0%" {
            zeroPctButton.isSelected = true
            tenPctButton.isSelected = false
            twentyPctButton.isSelected = false
            tipAmount = 0.0
        } else if tipLabel == "10%" {
            zeroPctButton.isSelected = false
            tenPctButton.isSelected = true
            twentyPctButton.isSelected = false
            tipAmount = 0.1
        } else {
            zeroPctButton.isSelected = false
            tenPctButton.isSelected = false
            twentyPctButton.isSelected = true
            tipAmount = 0.2
        }
        
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        splitNumberLabel.text = String(Int(sender.value))
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        totalBill = Float(billTextField.text!)!
        splitNumber = Float(splitNumberLabel.text!)!
        splitPayment = (totalBill * tipAmount) / splitNumber
        //add segue
        self.performSegue(withIdentifier: "goToResults", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResults" {
            //init segue
            let destinationVC = segue.destination as! ResultsViewController
            //overwrite segue properties
            destinationVC.splitPayment = self.splitPayment
            destinationVC.suggestionText = "Split between \(Int(splitNumber)) people with \(Int(tipAmount*100))% split."
        }
    }
    
}

