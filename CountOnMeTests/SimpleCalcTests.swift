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
    
    override func setUp() {
        super.setUp()
        self.calculatorModel = CalculatorModel()
    }

    override func tearDown() {
        self.calculatorModel = nil
        super.tearDown()
    }

    func testAddition() {
        let result = self.calculatorModel.add(3.0, 4.0)
        XCTAssertEqual(result, 7.0, "L'addition de 3.0 et 4.0 devrait être égale à 7.0")
    }
    
    func testSubtraction() {
        let result = self.calculatorModel.subtract(10.0, 4.0)
        XCTAssertEqual(result, 6.0, "La soustraction a échoué")
    }
    
    func testMultiplication() {
        let result = self.calculatorModel.multiply(7.0, 3.0)
        XCTAssertEqual(result, 21.0, "La multiplication a échoué")
    }
    
    func testDivision() {
        let result = self.calculatorModel.divide(20.0, 4.0)
        XCTAssertEqual(result, 5.0, "La division a échoué")
    }
    
    func testDivisionByZero() {
        let result = self.calculatorModel.divide(10.0, 0.0)
        XCTAssertTrue(result.isNaN, "La division par zéro n'a pas renvoyé NaN")
    }
    
    func testIsExpressionCorrect_ValidExpression() {
        let elements = ["5", "+", "3"]
        XCTAssertTrue(self.calculatorModel.isExpressionCorrect(elements: elements))
    }

    func testIsExpressionCorrect_InvalidExpression() {
        let elements = ["5", "+", "+"]
        XCTAssertFalse(self.calculatorModel.isExpressionCorrect(elements: elements))
    }

    func testDoesExpressionHaveEnoughElements_EnoughElements() {
        let elements = ["5", "+", "3", "*", "2"]
        XCTAssertTrue(self.calculatorModel.doesExpressionHaveEnoughElements(elements: elements))
    }

    func testDoesExpressionHaveEnoughElements_NotEnoughElements() {
        let elements = ["5", "+"]
        XCTAssertFalse(self.calculatorModel.doesExpressionHaveEnoughElements(elements: elements))
    }
    
    func testCanAddOperator_WithEmptyElements() {
        let calculatorModel = CalculatorModel()
        let elements: [String] = []
        let result = calculatorModel.canAddOperator(elements: elements)
        XCTAssertFalse(result, "Adding an operator to an empty array should not be allowed")
    }
    
    func testCanAddOperator_WithNonOperatorLastElement() {
        let calculatorModel = CalculatorModel()
        let elements = ["5", "+", "3"]
        let result = calculatorModel.canAddOperator(elements: elements)
        XCTAssertTrue(result, "Adding an operator when the last element is not an operator should be allowed")
    }
    
    func testCanAddOperator_WithOperatorLastElement() {
        let calculatorModel = CalculatorModel()
        let elements = ["5", "+", "3", "+"]
        let result = calculatorModel.canAddOperator(elements: elements)
        XCTAssertFalse(result, "Adding an operator when the last element is already an operator should not be allowed")
    }


    func testCanAddOperator_CannotAdd() {
        let elements = ["5", "+"]
        XCTAssertFalse(self.calculatorModel.canAddOperator(elements: elements))
    }

    func testDoesExpressionHaveResult_WithResult() {
        let text = "5 + 3 = 8"
        XCTAssertTrue(self.calculatorModel.doesExpressionHaveResult(text: text))
    }

    func testDoesExpressionHaveResult_NoResult() {
        let text = "5 + 3"
        XCTAssertFalse(self.calculatorModel.doesExpressionHaveResult(text: text))
    }
    
    func testCalculateExpression_SimpleAddition() {
        let expression = "5 + 3"
        let result = self.calculatorModel.calculateExpression(expression: expression)
        XCTAssertEqual(result, "= 8.0")
    }

    func testCalculateExpression_ComplexExpression() {
        let expression = "5 + 3 * 2 - 1"
        let result = self.calculatorModel.calculateExpression(expression: expression)
        XCTAssertEqual(result, "= 10.0")
    }

    func testCalculateExpression_DivisionByZero() {
        let expression = "5 / 0"
        let result = self.calculatorModel.calculateExpression(expression: expression)
        XCTAssertEqual(result, "Erreur : Division par zéro")
    }

}
