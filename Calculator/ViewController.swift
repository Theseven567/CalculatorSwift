//
//  ViewController.swift
//  Calculator
//
//  Created by Егор on 9/1/16.
//  Copyright © 2016 Егор. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var LabelOutput: UILabel!
    
    
    var isUserTyping = false;
    fileprivate var isFloatingDotPressed = false
    fileprivate var brain = Brain();
    
    @IBAction fileprivate func AddMathSymbol(_ sender: UIButton) {
        if isUserTyping {
            isUserTyping = false;
            brain.setOperand(displayValue)
        }
        if let symbolPressed = sender.currentTitle{
            brain.doOperation(symbolPressed)
        }
        if sender.currentTitle == "=" {
            isFloatingDotPressed = true
            displayValue = brain.result
            return
        }
        isFloatingDotPressed = false
        displayValue = brain.result
    }
    
    @IBOutlet weak var History: UILabel!
    
    fileprivate var  displayValue: Double{
        get{
            return Double(LabelOutput.text!)!
        }
        set{
            LabelOutput.text = String(newValue)
        }
    }
    
    @IBAction func FloatingDotButtonPressed(_ sender: UIButton) {
        if !isFloatingDotPressed{
            LabelOutput.text = LabelOutput.text! + "."
            isFloatingDotPressed = true
        }
    }
    var program: Brain.PropertyList?
    var output:String = ""
    @IBAction func save() {
        program = brain.program
        
    }
    
    @IBAction func restore() {
        if (program != nil){
            brain.program = program!
            displayValue = brain.result
            
        }
    }
    @IBAction func deleteLast(_ sender: UIButton) {
        let temp = LabelOutput.text
        if (temp) != ""{
        LabelOutput.text?.remove(at: (LabelOutput.text?.index(before: (LabelOutput.text?.endIndex)!))!)
        }
    }

    @IBAction fileprivate func DigitButtonPressed(_ sender: UIButton) {
        let digit = sender.currentTitle!;
        if(isUserTyping){
            LabelOutput.text = LabelOutput.text! + digit;
        }else{
            LabelOutput.text  = digit;
        }
        isUserTyping = true;
    }


}

