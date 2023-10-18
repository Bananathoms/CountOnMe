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
    var calculator: CalculatorModel!
    
    override func setUp() {
        super.setUp()
        calculator = CalculatorModel()
    }

    override func tearDown() {
        calculator = nil
        super.tearDown()
    }

    func testAddition() {
        let result = calculator.add(3.0, 4.0)
        XCTAssertEqual(result, 7.0, "L'addition de 3.0 et 4.0 devrait être égale à 7.0")
    }
    
    func testSubtraction() {
        let result = calculator.subtract(10.0, 4.0)
        XCTAssertEqual(result, 6.0, "La soustraction a échoué")
    }
    
    func testMultiplication() {
        let result = calculator.multiply(7.0, 3.0)
        XCTAssertEqual(result, 21.0, "La multiplication a échoué")
    }
    
    func testDivision() {
        let result = calculator.divide(20.0, 4.0)
        XCTAssertEqual(result, 5.0, "La division a échoué")
    }
    
    func testDivisionByZero() {
        let result = calculator.divide(10.0, 0.0)
        XCTAssertTrue(result.isNaN, "La division par zéro n'a pas renvoyé NaN")
    }

}
