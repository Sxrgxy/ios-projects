//
//  CalculatorBrain.swift
//  BMI Calculator
//
//  Created by dev on 13.07.2025.
//  Copyright © 2025 Angela Yu. All rights reserved.
//

import UIKit

struct CalculatorBrain {
    var bmi: BMI?
    
    mutating func calculateBMI(height: Float, weight: Float) {
        let bmiValue = weight/pow(height, 2)
        if bmiValue < 18.5 {
            bmi = BMI(value: bmiValue, advice: "Eat more pies!", color: UIColor.systemBlue)
        } else if bmiValue < 24.9 {
            bmi = BMI(value: bmiValue, advice: "You are fucking great!", color: UIColor.systemGreen)
        } else {
            bmi = BMI(value: bmiValue, advice: "Get on a fucking diet!", color: UIColor.systemPink)
        }
    }
    
    func getBMIValue() -> String {
        return String(format:"%.1f", bmi?.value ?? 0.0)
    }
    
    func getAdvice() -> String {
        return bmi?.advice ?? ""
    }
    
    func getColor() -> UIColor {
        return bmi?.color ?? UIColor.white
    }
}
