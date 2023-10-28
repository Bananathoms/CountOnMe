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

    func showAlert(message: String) {
        guard let viewController = viewController else {
            return
        }

        let alertVC = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        viewController.present(alertVC, animated: true, completion: nil)
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
    
    
}
