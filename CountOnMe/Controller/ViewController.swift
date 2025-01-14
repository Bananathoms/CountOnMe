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
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calculatorModel.delegate = self
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
        calculatorModel.tappedNumberButton(numberText)
    }
    
    /// Clears the content of the `textView`, resetting the expression.
    /// - Parameter sender: The button that triggers the clear action.
    @IBAction func tappedClearButton(_ sender: UIButton) {
        calculatorModel.resetCalcul()
    }
    
    /// Handles the user interaction when the back button is tapped, removing the last character from the current expression in the `textView`.
    /// - Parameter sender: The button representing the back button.
    @IBAction func tappedBackButton(_ sender: UIButton) {
        calculatorModel.tappedBackButton()
    }
    
    ///  Handles the user interaction when the equal button is tapped, performing the calculation and updating the `textView` with the result or an error message based on the current expression's validity.
    /// - Parameter sender: The button representing the operator button.
    @IBAction func tappedOperatorButton(_ sender: UIButton) {
        guard let operatorText = sender.title(for: .normal) else {
            return
        }
        calculatorModel.tappedOperatorButton(operatorText)
    }

    ///  Handles the user interaction when the equal button is tapped, performing the calculation and updating the `textView` with the result or an error message based on the current expression's validity.
    /// - Parameter sender: The button representing the equal button.
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calculatorModel.tappedEqualButton()
    }

    // CalculatorModelDelegate Methods
    func updateDisplay(value: String) {
        textView.text = value
    }
    
    func displayAlert(message: String) {
        showAlert(message: message)
    }
}

