//
//  CalculatorModel.swift
//  CountOnMe
//
//  Created by Thomas Carlier on 18/10/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import Foundation
import UIKit

class CalculatorModel {
    
    var viewController: UIViewController?
    var elements: [String] = []
    
    func isExpressionCorrect(elements: [String]) -> Bool {
        if let lastElement = elements.last {
            return lastElement != "+" && lastElement != "-" && lastElement != "*" && lastElement != "/"
        }
        return true
    }
    
    func doesExpressionHaveEnoughElements(elements: [String]) -> Bool {
        return elements.count >= 3
    }
    
    func canAddOperator(elements: [String]) -> Bool {
        if let lastElement = elements.last {
            return lastElement != "+" && lastElement != "-" && lastElement != "*" && lastElement != "/"
        }
        return false
    }
    
    func doesExpressionHaveResult(text: String) -> Bool {
        return text.firstIndex(of: "=") != nil
    }
    
    func add(_ left: Double, _ right: Double) -> Double {
        return left + right
    }

    func subtract(_ left: Double, _ right: Double) -> Double {
        return left - right
    }

    func multiply(_ left: Double, _ right: Double) -> Double {
        return left * right
    }

    func divide(_ left: Double, _ right: Double) -> Double {
        if right != 0 {
            return left / right
        } else {
            return Double.nan
        }
    }
    
    func calculateExpression(expression: String) -> String {
        self.elements = expression.split(separator: " ").map { "\($0)" }

        while self.elements.contains("*") || self.elements.contains("/") {
            if let index = self.elements.firstIndex(where: { $0 == "*" || $0 == "/" }) {
                let left = Double(self.elements[index - 1])!
                let operand = self.elements[index]
                let right = Double(self.elements[index + 1])!

                let result: Double

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

                self.elements[index - 1] = String(result)
                self.elements.remove(at: index)
                self.elements.remove(at: index)
            }
        }

        while self.elements.count > 1 {
            let left = Double(self.elements[0])!
            let operand = self.elements[1]
            let right = Double(self.elements[2])!

            let result: Double

            if operand == "+" {
                result = self.add(left, right)
            } else if operand == "-" {
                result = self.subtract(left, right)
            } else {
                return "Opérateur inconnu !"
            }

            self.elements = Array(self.elements.dropFirst(3))
            self.elements.insert(String(result), at: 0)
        }
        return "= \(self.elements.first ?? "Erreur")"
    }
}
