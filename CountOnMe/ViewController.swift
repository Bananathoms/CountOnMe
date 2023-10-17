//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    var elements: [String] {
        return textView.text.split(separator: " ").map { "\($0)" }
    }
    
    /// check if last element is not an operand
    var expressionIsCorrect: Bool {
        if let lastElement = elements.last {
            return lastElement != "+" && lastElement != "-" && lastElement != "*" && lastElement != "/"
        }
        return true
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    
    var canAddOperator: Bool {
        if let lastElement = elements.last {
            return lastElement != "+" && lastElement != "-" && lastElement != "*" && lastElement != "/"
        }
        return false
    }
    
    var expressionHaveResult: Bool {
        return textView.text.firstIndex(of: "=") != nil
    }
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        
        if expressionHaveResult {
            textView.text = ""
        }
        
        /// Decimal Button verification
        if numberText == "." {
            /// Security to only have one .
            if let lastElement = elements.last, lastElement.contains(".") {
                return
            }
        }
        textView.text.append(numberText)
    }
    
    @IBAction func tappedClearButton(_ sender: UIButton) {
        textView.text = ""
    }
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        if !textView.text.isEmpty {
            textView.text.removeLast()
        }
    }
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        if canAddOperator {
            textView.text.append(" + ")
        } else {
            showAlert(message: "Un operateur est déja mis !")
        }
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        if canAddOperator {
            textView.text.append(" - ")
        } else {
            showAlert(message: "Un operateur est déja mis !")
        }
    }
    
    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        if canAddOperator {
            textView.text.append(" * ")
        } else {
            showAlert(message: "Un operateur est déja mis !")
        }
    }

    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        if canAddOperator {
            textView.text.append(" / ")
        } else {
            showAlert(message: "Un operateur est déja mis !")
        }
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard expressionIsCorrect else {
            showAlert(message: "Entrez une expression correcte !")
            return
        }

        guard expressionHaveEnoughElement else {
            showAlert(message: "Démarrez un nouveau calcul !")
            return
        }

        var operationsToReduce = elements

        while operationsToReduce.count > 1 {
            if let left = Double(operationsToReduce[0]), let right = Double(operationsToReduce[2]) {
                let operand = operationsToReduce[1]
                var result: Double?

                switch operand {
                case "+": result = left + right
                case "-": result = left - right
                case "*": result = left * right
                case "/":
                    if right != 0 {
                        result = left / right
                    } else {
                        showAlert(message: "Division par zéro !")
                        return
                    }
                default:
                    showAlert(message: "Opérateur inconnu !")
                    return
                }

                if let result = result {
                    operationsToReduce = Array(operationsToReduce.dropFirst(3))
                    operationsToReduce.insert("\(result)", at: 0)
                } else {
                    showAlert(message: "Erreur de calcul !")
                    return
                }
            } else {
                showAlert(message: "Opérandes invalides !")
                return
            }
        }

        textView.text.append(" = \(operationsToReduce.first!)")
    }


    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

    
}

