//
//  Extension+ViewController.swift
//  CountOnMe
//
//  Created by Thomas Carlier on 21/11/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import Foundation

extension ViewController: CalculatorModelDelegate {
    func calculatorModel(_ calculatorModel: CalculatorModel, didEncounterError message: String) {
        self.showAlert(message: message)
    }
}
