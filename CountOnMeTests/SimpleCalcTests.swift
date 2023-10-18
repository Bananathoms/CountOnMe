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
        calculatorModel = CalculatorModel()
    }

    override func tearDown() {
        calculatorModel = nil
        super.tearDown()
    }

    func testAddition() {
        let result = calculatorModel.add(3.0, 4.0)
        XCTAssertEqual(result, 7.0, "L'addition de 3.0 et 4.0 devrait être égale à 7.0")
    }

}
