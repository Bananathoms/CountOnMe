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
    var elements: [String] = []
    
    var expression: String = "" {
        didSet {
            self.elements = self.expression.split(separator: " ").map { "\($0)" }
        }
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
        self.elements = expression.split(separator: " ").map { "\($0)" }

        guard isExpressionCorrect(elements: self.elements), doesExpressionHaveEnoughElements(elements: self.elements) else {
            return "Erreur : Expression invalide"
        }
        
        while self.elements.contains("*") || self.elements.contains("/") {
            if let index = self.elements.firstIndex(where: { $0 == "*" || $0 == "/" }),
               let left = Double(self.elements[index - 1]),
               let right = Double(self.elements[index + 1]) {

                let operand = self.elements[index]
                var result: Double?

                if operand == "*" {
                    result = self.multiply(left, right)
                } else if operand == "/" {
                    if right != 0 {
                        result = self.divide(left, right)
                    } else {
                        return "Erreur : Division par zéro"
                    }
                } else {
                    return "Opérateur inconnu !"
                }

                if let result = result {
                    self.elements[index - 1] = String(result)
                    self.elements.remove(at: index)
                    self.elements.remove(at: index)
                }
            }
        }

        while self.elements.count > 1 {
            if let left = Double(self.elements[0]),
               let right = Double(self.elements[2]) {

                let operand = self.elements[1]
                var result: Double?

                if operand == "+" {
                    result = self.add(left, right)
                } else if operand == "-" {
                    result = self.subtract(left, right)
                } else {
                    return "Opérateur inconnu !"
                }

                if let result = result {
                    self.elements = Array(self.elements.dropFirst(3))
                    self.elements.insert(String(result), at: 0)
                }
            }
        }
        return "= \(self.elements.first ?? "Erreur")"
    }
}

protocol CalculatorModelDelegate: AnyObject {
    func calculatorModel(_ calculatorModel: CalculatorModel, didEncounterError message: String)
}

