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
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
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
        self.displayButtonInput(input: " + ")
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        self.displayButtonInput(input: " - ")
    }
    
    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        self.displayButtonInput(input: " * ")
    }

    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        self.displayButtonInput(input: " / ")
    }
    
    func displayButtonInput(input: String) {
        if self.calculatorModel.canAddOperator(elements: self.elements) {
            self.textView.text.append(input)
        } else {
            self.showAlert(message: "Un operateur est déja mis !")
        }
    }

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

