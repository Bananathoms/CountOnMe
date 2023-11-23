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
        XCTAssertEqual(result, 7.0)
    }
    
    func testSubtraction() {
        let result = self.calculatorModel.subtract(10.0, 4.0)
        XCTAssertEqual(result, 6.0)
    }
    
    func testMultiplication() {
        let result = self.calculatorModel.multiply(7.0, 3.0)
        XCTAssertEqual(result, 21.0)
    }
    
    func testDivision() {
        let result = self.calculatorModel.divide(20.0, 4.0)
        XCTAssertEqual(result, 5.0)
    }
    
    func testDivisionByZero() {
        let result = self.calculatorModel.divide(10.0, 0.0)
        XCTAssertTrue(result.isNaN)
    }
    func testIsExpressionValid_WhenValid() {
        calculatorModel.expression = "5 + 3"
        XCTAssertTrue(calculatorModel.isExpressionValid())
    }

    func testIsExpressionValid_WhenInvalid() {
        calculatorModel.expression = "5 +"
        XCTAssertFalse(calculatorModel.isExpressionValid())
    }

    func testIsExpressionValid_WhenNotEnoughElements() {
        calculatorModel.expression = "5"
        XCTAssertFalse(calculatorModel.isExpressionValid())
    }

    
    func testCanAddOperator_WithEmptyExpression() {
        self.calculatorModel.expression = ""
        XCTAssertFalse(self.calculatorModel.canAddOperator)
    }
    
    func testCanAddOperator_WithNonOperatorLastElement() {
        self.calculatorModel.expression = "5 + 3"
        XCTAssertTrue(self.calculatorModel.canAddOperator)
    }
    
    func testCanAddOperator_WithOperatorLastElement() {
        self.calculatorModel.expression = "5 + 3 +"
        XCTAssertFalse(self.calculatorModel.canAddOperator)
    }
    
    func testDoesExpressionHaveResult_WithResult() {
        self.calculatorModel.expression = "5 + 3 = 8"
        XCTAssertTrue(self.calculatorModel.doesExpressionHaveResult)
    }
    
    func testDoesExpressionHaveResult_NoResult() {
        self.calculatorModel.expression = "5 + 3"
        XCTAssertFalse(self.calculatorModel.doesExpressionHaveResult)
    }
    
    func testCalculateExpression_SimpleAddition() {
        self.calculatorModel.expression = "5 + 3"
        let result = self.calculatorModel.calculateExpression(expression: self.calculatorModel.expression)
        XCTAssertEqual(result, "= 8.0")
    }
    
    func testCalculateExpression_ComplexExpression() {
        self.calculatorModel.expression = "5 + 3 * 2 - 1"
        let result = self.calculatorModel.calculateExpression(expression: self.calculatorModel.expression)
        XCTAssertEqual(result, "= 10.0")
    }
    
    func testCalculateExpression_Division() {
        self.calculatorModel.expression = "10 / 5"
        let result = self.calculatorModel.calculateExpression(expression: self.calculatorModel.expression)
        XCTAssertEqual(result, "= 2.0")
    }
    
    func testCalculateExpression_DivisionByZero() {
        self.calculatorModel.expression = "5 / 0"
        let result = self.calculatorModel.calculateExpression(expression: self.calculatorModel.expression)
        XCTAssertEqual(result, "Erreur : Division par zéro")
    }
    
    func testCalculateExpression_WhenExpressionIsValid() {
        calculatorModel.expression = "5 + 3"
        let result = calculatorModel.calculateExpression(expression: self.calculatorModel.expression)
        XCTAssertEqual(result, "= 8.0")
    }

    func testCalculateExpression_WhenExpressionIsInvalid() {
        calculatorModel.expression = "5 +"
        let result = calculatorModel.calculateExpression(expression: self.calculatorModel.expression)
        XCTAssertEqual(result, "Erreur : Expression invalide")
    }

    func testCalculateExpression_WhenNotEnoughElements() {
        calculatorModel.expression = "5"
        let result = calculatorModel.calculateExpression(expression: self.calculatorModel.expression)
        XCTAssertEqual(result, "Erreur : Expression invalide")
    }
}
