//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let calculatorModel = CalculatorModel()
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    var elements: [String] {
        return self.textView.text.split(separator: " ").map { "\($0)" }
    }
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calculatorModel.viewController = self
    }
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        
        if self.calculatorModel.doesExpressionHaveResult(text: textView.text) {
            self.textView.text = ""
        }
        
        /// Decimal Button verification
        if numberText == "." {
            /// Security to only have one .
            if let lastElement = self.elements.last, lastElement.contains(".") {
                return
            }
        }
        self.textView.text.append(numberText)
    }
    
    @IBAction func tappedClearButton(_ sender: UIButton) {
        self.textView.text = ""
    }
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        if !self.textView.text.isEmpty {
            self.textView.text.removeLast()
        }
    }
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        if self.calculatorModel.canAddOperator(elements: self.elements) {
            self.textView.text.append(" + ")
        } else {
            self.calculatorModel.showAlert(message: "Un operateur est déja mis !")
        }
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        if self.calculatorModel.canAddOperator(elements: self.elements) {
            self.textView.text.append(" - ")
        } else {
            self.calculatorModel.showAlert(message: "Un operateur est déja mis !")
        }
    }
    
    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        if self.calculatorModel.canAddOperator(elements: self.elements) {
            self.textView.text.append(" * ")
        } else {
            self.calculatorModel.showAlert(message: "Un operateur est déja mis !")
        }
    }

    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        if self.calculatorModel.canAddOperator(elements: self.elements) {
            self.textView.text.append(" / ")
        } else {
            self.calculatorModel.showAlert(message: "Un operateur est déja mis !")
        }
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        let isCorrect = self.calculatorModel.isExpressionCorrect(elements: self.elements)
        let haveEnoughElements = self.calculatorModel.doesExpressionHaveEnoughElements(elements: self.elements)
        let hasResult = self.calculatorModel.doesExpressionHaveResult(text: self.textView.text)

        if hasResult {
            self.textView.text = ""
        }

        guard isCorrect else {
            self.calculatorModel.showAlert(message: "Entrez une expression correcte !")
            return
        }

        guard haveEnoughElements else {
            self.calculatorModel.showAlert(message: "Démarrez un nouveau calcul !")
            return
        }

        var operationsToReduce = self.elements

        /// multiplication and division
        while operationsToReduce.contains("*") || operationsToReduce.contains("/") {
            if let index = operationsToReduce.firstIndex(where: { $0 == "*" || $0 == "/" }) {
                let left = Double(operationsToReduce[index - 1])!
                let operand = operationsToReduce[index]
                let right = Double(operationsToReduce[index + 1])!

                let model = CalculatorModel()
                let result: Double
                switch operand {
                case "*": result = model.multiply(left, right)
                case "/": result = model.divide(left, right)
                default:
                    fatalError("Opérateur inconnu !")
                }

                operationsToReduce[index - 1] = String(result)
                operationsToReduce.remove(at: index)
                operationsToReduce.remove(at: index)
            }
        }

        /// Addition and substraction
        while operationsToReduce.count > 1 {
            let left = Double(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Double(operationsToReduce[2])!

            let model = CalculatorModel()
            let result: Double
            switch operand {
            case "+": result = model.add(left, right)
            case "-": result = model.subtract(left, right)
            default:
                fatalError("Opérateur inconnu !")
            }

            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert(String(result), at: 0)
        }

        self.textView.text.append(" = \(operationsToReduce.first!)")
    }
}

