//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Angela Yu on 21/08/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class CalculateViewController: UIViewController {
    
    var calculatorBrain = CalculatorBrain()
    
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!

    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    
    
    @IBAction func heightSliderChanged(_ sender: UISlider) {
        let height = String(format: "%.2f", sender.value)
        heightLabel.text = "\(height)m"
    }
    
    @IBAction func weightSliderChanged(_ sender: UISlider) {
        let weight = String(format: "%.0f", sender.value)
        weightLabel.text = "\(weight)Kg"
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        let height = heightSlider.value
        let weight = weightSlider.value
        
        //calls a calculateBMI function inside calculatorBrain struct
        calculatorBrain.calculateBMI(height: height, weight: weight)
        
        //trigger another screen "goToResult" to pop up after pressing Calculate on a first screen
        self.performSegue(withIdentifier: "goToResult", sender: self)
        
    }
    
    // prepare second View before showing instead of a first view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //check which View is to prepare before segue
        if segue.identifier == "goToResult" {
            //on the right is a ViewController that will be displayed during segue
            // use as! to give a reference to a default UIViewController to be a concrete VC
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.bmiValue = calculatorBrain.getBMIValue()
            destinationVC.advice = calculatorBrain.getAdvice()
            destinationVC.color = calculatorBrain.getColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

