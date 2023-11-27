//
//  CalculatorModel.swift
//  CountOnMe
//
//  Created by Thomas Carlier on 18/10/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import Foundation

class CalculatorModel {
    
    weak var delegate: CalculatorModelDelegate?
    var elements: [String] {
        self.expression.split(separator: " ").map { "\($0)" }
    }
    
    var expression: String = "" {
        didSet {
            delegate?.updateDisplay(value: expression)
        }
    }
    
    func tappedNumberButton(_ numberText: String) {
        if doesExpressionHaveResult {
            expression = ""
        }
        
        expression.append(numberText)
    }
    
    func tappedOperatorButton(_ mathOperator: String) {
        guard canAddOperator else {
            delegate?.displayAlert(message: "Un opérateur est déjà présent")
            return
        }
        
        if doesExpressionHaveResult {
            expression = ""
        }
        
        expression.append(" \(mathOperator) ")
    }
    
    func resetCalcul() {
        expression.removeAll()
    }
    
    func tappedBackButton() {
        if !expression.isEmpty {
            expression.removeLast()
        }
    }
    
    func tappedEqualButton() {
        guard isExpressionValid() else {
            delegate?.displayAlert(message: "Expression non valide")
            return
        }
        expression = calculateExpression(expression: expression)
    }
    
    /// Determines whether it's possible to add an operator to the given expression by checking if the last element is not already an operator.
    var canAddOperator: Bool {
        if let lastElement = elements.last {
            return lastElement != "+" && lastElement != "-" && lastElement != "*" && lastElement != "/"
        }
        return false
    }
    
    /// Checks if the given text represents an expression with a calculated result, indicated by the presence of the equal sign ('=').
    var doesExpressionHaveResult: Bool {
        return expression.firstIndex(of: "=") != nil
    }
    
    func isExpressionValid() -> Bool {
        return isExpressionCorrect(elements: elements) && doesExpressionHaveEnoughElements(elements: elements)
    }
    
    /// Checks whether the given expression is correct by verifying that the last element in the expression array is not an operator.
    /// - Parameter elements: The elements of the expression to be checked.
    /// - Returns: `true` if the expression is correct; otherwise, it returns `false`.
    func isExpressionCorrect(elements: [String]) -> Bool {
        if let lastElement = elements.last {
            return lastElement != "+" && lastElement != "-" && lastElement != "*" && lastElement != "/"
        }
        return true
    }
    
    /// Checks if the given expression has the minimum required number of elements for a valid mathematical operation.
    /// - Parameter elements: The elements of the expression to be checked.
    /// - Returns: `true` if the expression has three or more elements, indicating it has enough for a valid operation; otherwise, it returns `false`.
    func doesExpressionHaveEnoughElements(elements: [String]) -> Bool {
        return elements.count >= 3
    }
    
    func isNumberValid(_ numberString: String) -> Bool {
        // Vérifie si la chaîne est un nombre valide et pas juste un point
        return Double(numberString) != nil && numberString != "."
    }
    
    /// Performs addition of two numbers and returns the result.
    /// - Parameters:
    ///   - left: The left operand of the addition operation.
    ///   - right: The right operand of the addition operation.
    /// - Returns: The sum of `left` and `right`, as a `Double`.
    func add(_ left: Double, _ right: Double) -> Double {
        return left + right
    }
    
    /// Performs substraction of two numbers and returns the result.
    /// - Parameters:
    ///   - left: The left operand of the substraction operation.
    ///   - right: The right operand of the substraction operation.
    /// - Returns: The substract ion of `left` and `right`, as a `Double`.
    func subtract(_ left: Double, _ right: Double) -> Double {
        return left - right
    }
    
    /// Performs  multiplication of two numbers and returns the result.
    /// - Parameters:
    ///   - left: The left operand of the multiplication operation.
    ///   - right: The right operand of the multiplication operation.
    /// - Returns: The multiplication of `left` and `right`, as a `Double`.
    func multiply(_ left: Double, _ right: Double) -> Double {
        return left * right
    }
    
    /// Performs division of two numbers and returns the result.
    /// - Parameters:
    ///   - left: The left operand of the division  operation.
    ///   - right: The right operand of the division  operation.
    /// - Returns: The division  of `left` and `right`, as a `Double`.
    func divide(_ left: Double, _ right: Double) -> Double {
        if right != 0 {
            return left / right
        } else {
            return Double.nan
        }
    }
    
    /// Parses and evaluates the given mathematical expression and returns the result as a formatted string.
    /// - Parameter expression: The mathematical expression to be calculated, containing numbers and operators.
    /// - Returns: A formatted string representing the result of the expression, including an equal sign ('=') at the beginning, or an error message if the expression is invalid or contains division by zero.
    func calculateExpression(expression: String) -> String {
        var tempElements = elements
        
        guard isExpressionCorrect(elements: tempElements), doesExpressionHaveEnoughElements(elements: tempElements) else {
            delegate?.displayAlert(message: "Expression invalide")
            return ""
        }
        
        while let index = tempElements.firstIndex(where: { $0 == "*" || $0 == "/" }) {
            guard index > 0, index < tempElements.count - 1,
                  isNumberValid(tempElements[index - 1]), isNumberValid(tempElements[index + 1]),
                  let left = Double(tempElements[index - 1]),
                  let right = Double(tempElements[index + 1]) else {
                delegate?.displayAlert(message: "Nombre non valide détecté")
                return ""
            }
            
            let operand = tempElements[index]
            var result: Double?
            
            switch operand {
            case "*":
                result = multiply(left, right)
            case "/":
                if right == 0 {
                    delegate?.displayAlert(message: "Erreur : Division par zéro")
                    return ""
                }
                result = divide(left, right)
            default:
                delegate?.displayAlert(message: "Opérateur inconnu !")
                return ""
            }
            
            if let result = result {
                tempElements[index - 1] = String(result)
                tempElements.remove(at: index + 1)
                tempElements.remove(at: index)
            }
        }
        
        while tempElements.count > 1 {
            guard let left = Double(tempElements[0]),
                  let right = Double(tempElements[2]),
                  tempElements.count >= 3 else {
                delegate?.displayAlert(message: "Expression non valide pour l'addition/soustraction")
                return ""
            }
            
            let operand = tempElements[1]
            var result: Double?
            
            switch operand {
            case "+":
                result = add(left, right)
            case "-":
                result = subtract(left, right)
            default:
                delegate?.displayAlert(message: "Opérateur inconnu !")
                return ""
            }
            
            if let result = result {
                tempElements = Array(tempElements.dropFirst(3))
                tempElements.insert(String(result), at: 0)
            }
        }
        return "= \(tempElements.first ?? "Erreur")"
    }
}

protocol CalculatorModelDelegate: AnyObject {
    func updateDisplay(value: String)
    func displayAlert(message: String)
}
