//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Егор on 9/3/16.
//  Copyright © 2016 Егор. All rights reserved.
//

import Foundation


class Brain {
    
    
    fileprivate var accumulator = 0.0
    fileprivate var internalProgram = [AnyObject]()
    

    
    func setOperand(_ operand: Double){
        accumulator = operand;
        internalProgram.append(operand as AnyObject)
    }
    
    var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(M_PI),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos":Operation.unaryOperation(cos),
        "×" :Operation.binaryOperation({$0 * $1}),
        "+":Operation.binaryOperation({$0 + $1}),
        "-":Operation.binaryOperation({$0 - $1}),
        "÷":Operation.binaryOperation({$0 / $1}),
        "=" : Operation.equals,
        "CE" : Operation.clear
    ]
    
    enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
        case clear
    }

    
    func doOperation(_ symbol: String){
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol]{
            switch operation {
            case .constant(let value): accumulator = value
            case .unaryOperation(let function):accumulator = function(accumulator)
            case .binaryOperation(let function):
                executeBinaryOperation()
                pending = BinaryOperationInfo(binaryFunction: function, firstNum: accumulator)
            case .equals:
                executeBinaryOperation()
                pending = nil
            case .clear:
                accumulator = 0.0;
                pending = nil
            }
            
        }
 
    }
    
    
    fileprivate func executeBinaryOperation(){
        if (pending != nil){
            accumulator = pending!.binaryFunction(pending!.firstNum, accumulator)
        }
    }
    
    typealias PropertyList = AnyObject
    fileprivate var pending: BinaryOperationInfo?
    
    var program: PropertyList{
        get{
          return internalProgram as Brain.PropertyList
        }
        set{
            clear()
            if let arrOfOperation = newValue as? [AnyObject]{
                for op in arrOfOperation{
                    if let operand = op as? Double{
                        setOperand(operand)
                    }else if let operation = op as? String{
                        doOperation(operation)
                    }
                }
            }
        }
    }
    
    fileprivate func clear(){
        accumulator = 0
        pending = nil
        internalProgram.removeAll()
    }
    
    fileprivate struct BinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstNum: Double
        
    }
    func returnStringRepresentatoinOfTheOperaions() -> String{
        var output = ""
        for op in internalProgram{
            output = output + String(describing: op)
        }
        return output
    }
    
    var result: Double{
        get {
            return accumulator
        }
    }

    
}
