//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CalculatorModelDelegate {
    
    let calculatorModel = CalculatorModel()
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    var elements: [String] {
        return self.textView.text.split(separator: " ").map { "\($0)" }
    }
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calculatorModel.delegate = self
    }
    
    func calculatorModel(_ calculatorModel: CalculatorModel, didEncounterError message: String) {
        self.showAlert(message: message)
    }
    
    /// Displays an alert with a custom error message to inform the user about invalid inputs or operations.
    /// - Parameter message: The error message to be presented in the alert.
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

    
    // View actions
    /// Handles the user interaction when a number button is tapped, appending the number to the current expression in the `textView`. It also ensures that only one decimal point is allowed for each number.
    /// - Parameter sender: The button representing the tapped number.
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
    
    /// Clears the content of the `textView`, resetting the expression.
    /// - Parameter sender: The button that triggers the clear action.
    @IBAction func tappedClearButton(_ sender: UIButton) {
        self.textView.text = ""
    }
    
    /// Handles the user interaction when the back button is tapped, removing the last character from the current expression in the `textView`.
    /// - Parameter sender: The button representing the back button.
    @IBAction func tappedBackButton(_ sender: UIButton) {
        if !self.textView.text.isEmpty {
            self.textView.text.removeLast()
        }
    }
    
    /// Handles the user interaction when the addition button is tapped, appending the addition operator (' + ') to the current expression.
    /// - Parameter sender: The button representing the addition button.
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        self.displayButtonInput(input: " + ")
    }
    
    /// Handles the user interaction when the subtraction button is tapped, appending the subtraction operator (' - ') to the current expression.
    /// - Parameter sender: The button representing the subtraction button.
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        self.displayButtonInput(input: " - ")
    }
    
    /// Handles the user interaction when the multiplication button is tapped, appending the multiplication operator (' * ') to the current expression.
    /// - Parameter sender: The button representing the multiplication button.
    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        self.displayButtonInput(input: " * ")
    }
    
    /// Handles the user interaction when the division button is tapped, appending the division operator (' / ') to the current expression.
    /// - Parameter sender: The button representing the division button.
    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        self.displayButtonInput(input: " / ")
    }
    
    ///  Appends the given input to the `textView` only if adding an operator is allowed based on the current expression.
    /// - Parameter input: The operator or input to be added.
    func displayButtonInput(input: String) {
        if self.calculatorModel.canAddOperator(elements: self.elements) {
            self.textView.text.append(input)
        } else {
            self.showAlert(message: "Un operateur est déja mis !")
        }
    }
    
    ///  Handles the user interaction when the equal button is tapped, performing the calculation and updating the `textView` with the result or an error message based on the current expression's validity.
    /// - Parameter sender: The button representing the equal button.
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        let isCorrect = self.calculatorModel.isExpressionCorrect(elements: self.elements)
        let haveEnoughElements = self.calculatorModel.doesExpressionHaveEnoughElements(elements: self.elements)
        let hasResult = self.calculatorModel.doesExpressionHaveResult(text: self.textView.text)
        
        guard let expression = self.textView.text else {
            return
        }
        
        let result = self.calculatorModel.calculateExpression(expression: expression)

        if hasResult {
            self.textView.text = ""
        }

        guard isCorrect else {
            self.showAlert(message: "Entrez une expression correcte !")
            return
        }

        guard haveEnoughElements else {
            self.showAlert(message: "Démarrez un nouveau calcul !")
            return
        }
        
        self.textView.text = result
    }
}

