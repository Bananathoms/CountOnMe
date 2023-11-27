//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class SimpleCalcTests: XCTestCase {
    
    var calculatorModel: CalculatorModel!
    var delegateMock: CalculatorModelDelegateMock!
    
    override func setUp() {
        super.setUp()
        calculatorModel = CalculatorModel()
        delegateMock = CalculatorModelDelegateMock()
        calculatorModel.delegate = delegateMock
    }
    
    override func tearDown() {
        calculatorModel = nil
        super.tearDown()
    }
    
    func testSimpleOperation() {
        calculatorModel.tappedNumberButton("2")
        calculatorModel.tappedOperatorButton("+")
        calculatorModel.tappedNumberButton("2")
        calculatorModel.tappedEqualButton()
        
        XCTAssertEqual(delegateMock.lastDisplayedValue, "= 4.0")
    }
    
    func testComplexOperation() {
        calculatorModel.tappedNumberButton("2")
        calculatorModel.tappedOperatorButton("*")
        calculatorModel.tappedNumberButton("3")
        calculatorModel.tappedOperatorButton("+")
        calculatorModel.tappedNumberButton("5")
        calculatorModel.tappedOperatorButton("*")
        calculatorModel.tappedNumberButton("4")
        calculatorModel.tappedOperatorButton("-")
        calculatorModel.tappedNumberButton("4")
        calculatorModel.tappedOperatorButton("/")
        calculatorModel.tappedNumberButton("2")
        calculatorModel.tappedEqualButton()
        
        XCTAssertEqual(delegateMock.lastDisplayedValue, "= 24.0")
    }
    
    func testClear() {
        calculatorModel.resetCalcul()
        
        XCTAssertEqual(calculatorModel.expression, "")
    }
    
    func testBack(){
        calculatorModel.tappedNumberButton("2")
        calculatorModel.tappedNumberButton("3")
        calculatorModel.tappedBackButton()
        
        XCTAssertEqual(calculatorModel.expression, "2")
    }

    func testDivideByZero() {
        let result = calculatorModel.divide(9, 0)
        calculatorModel.tappedNumberButton("9")
        calculatorModel.tappedOperatorButton("/")
        calculatorModel.tappedNumberButton("0")
        calculatorModel.tappedEqualButton()
        
        
        XCTAssertEqual(delegateMock.alertMessage, "Erreur : Division par zéro")
        XCTAssertEqual(calculatorModel.expression, "")
        XCTAssertTrue(result.isNaN)
    }
    
    func testTappedNumberButton_WithResult() {
        calculatorModel.expression = "5 + 5 = 10"
        calculatorModel.tappedNumberButton("3")
        
        XCTAssertEqual(calculatorModel.expression, "3")
    }

    func testTappedNumberButton_WithoutResult() {
        calculatorModel.expression = "5 + 5"
        calculatorModel.tappedNumberButton("3")
        
        XCTAssertEqual(calculatorModel.expression, "5 + 53")
    }
    
    func testTappedOperatorButton_WhenOperatorCannotBeAdded() {
        calculatorModel.expression = "5 +"
        calculatorModel.tappedOperatorButton("+")

        XCTAssertNotNil(delegateMock.alertMessage)
        XCTAssertEqual(delegateMock.alertMessage, "Un opérateur est déjà présent")
    }

    func testTappedOperatorButton_WhenOperatorCanBeAdded() {
        calculatorModel.expression = "5"
        calculatorModel.tappedOperatorButton("+")

        XCTAssertEqual(calculatorModel.expression, "5 + ")
    }
    
    func testCanAddOperator_WhenExpressionIsEmpty() {
        calculatorModel.expression = ""
        XCTAssertFalse(calculatorModel.canAddOperator)
    }

    func testTappedOperatorButton_afterResult() {
        calculatorModel.tappedNumberButton("5")
        calculatorModel.tappedOperatorButton("+")
        calculatorModel.tappedNumberButton("5")
        calculatorModel.tappedEqualButton()
        calculatorModel.tappedOperatorButton("+")
        
        XCTAssertEqual(calculatorModel.expression, "10.0 + ")
    }
    
    func testTappedEqualButton_WhenExpressionIsInvalid() {
        calculatorModel.expression = "5 +"
        calculatorModel.tappedEqualButton()

        XCTAssertNotNil(delegateMock.alertMessage)
        XCTAssertEqual(delegateMock.alertMessage, "Expression non valide")
    }
    
    func testTappedEqualButton_WhenInvalidNumber() {
        let invalidExpressions = ["5 * .", "7 / .", "3 + .", "4 - .", ". * 3"]
        
        for expression in invalidExpressions {
            calculatorModel.expression = expression
            calculatorModel.tappedEqualButton()
            
            XCTAssertNotNil(delegateMock.alertMessage)
            XCTAssertEqual(delegateMock.alertMessage, "Nombre non valide")
        }
    }
    
    func testTappedEqualButton_WhenNotEnoughtElements() {
        let result = calculatorModel.calculateExpression(expression: "2")
        
        XCTAssertEqual(delegateMock.alertMessage, "Expression invalide")
        XCTAssertEqual(result, "")
    }
    
    func testTappedEqualButton_WhenUnknownOperator() {
        calculatorModel.expression = "2 # 3"

        let result = calculatorModel.calculateExpression(expression: calculatorModel.expression)

        XCTAssertEqual(delegateMock.alertMessage, "Opérateur inconnu !")
        XCTAssertEqual(result, "")
    }
}

class CalculatorModelDelegateMock: CalculatorModelDelegate {
    var alertMessage: String?
    var lastDisplayedValue: String?

    func updateDisplay(value: String) {
        lastDisplayedValue = value
    }

    func displayAlert(message: String) {
        alertMessage = message
    }
}
