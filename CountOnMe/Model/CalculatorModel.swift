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

    func showAlert(message: String) {
        guard let viewController = self.viewController else {
            return
        }

        let alertVC = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        viewController.present(alertVC, animated: true, completion: nil)
    }
    
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
        elements = expression.split(separator: " ").map { "\($0)" }

        // Effectuer le calcul en respectant la priorité des opérations
        while elements.contains("*") || elements.contains("/") {
            if let index = elements.firstIndex(where: { $0 == "*" || $0 == "/" }) {
                let left = Double(elements[index - 1])!
                let operand = elements[index]
                let right = Double(elements[index + 1])!

                let result: Double
                switch operand {
                case "*":
                    result = multiply(left, right)
                case "/":
                    if right != 0 {
                        result = divide(left, right)
                    } else {
                        return "Erreur : Division par zéro"
                    }
                default:
                    fatalError("Opérateur inconnu !")
                }

                elements[index - 1] = String(result)
                elements.remove(at: index)
                elements.remove(at: index)
            }
        }

        while elements.count > 1 {
            let left = Double(elements[0])!
            let operand = elements[1]
            let right = Double(elements[2])!

            let result: Double
            switch operand {
            case "+":
                result = add(left, right)
            case "-":
                result = subtract(left, right)
            default:
                fatalError("Opérateur inconnu !")
            }

            elements = Array(elements.dropFirst(3))
            elements.insert(String(result), at: 0)
        }

        return "= \(elements.first ?? "Erreur")"
    }
    
}
