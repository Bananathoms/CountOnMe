//
//  ViewControllerTest.swift
//  CountOnMeTests
//
//  Created by Thomas Carlier on 06/11/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//
//
//import XCTest
//@testable import CountOnMe
//
//final class ViewControllerTest: XCTestCase {
//
//    class MockViewController: UIViewController {
//        var presentedAlert: UIAlertController?
//
//        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
//            presentedAlert = viewControllerToPresent as? UIAlertController
//        }
//    }
//
//    var calculatorModel: CalculatorModel!
//
//    override func setUp() {
//        super.setUp()
//        self.calculatorModel = CalculatorModel()
//    }
//
//    override func tearDown() {
//        self.calculatorModel = nil
//        super.tearDown()
//    }
//
//    func testShowAlert() {
//        let mockViewController = MockViewController()
//
//        self.calculatorModel.viewController = mockViewController
//
//        let message = "This is a test message."
//        self.calculatorModel.showAlert(message: message)
//
//        XCTAssertNotNil(mockViewController.presentedAlert, "An alert should have been presented")
//        XCTAssertEqual(mockViewController.presentedAlert?.message, message, "Alert message should match")
//        XCTAssertEqual(mockViewController.presentedAlert?.title, "Erreur", "Alert title should match")
//    }
//
//    func testShowAlertWithoutViewController() {
//        let message = "This is a test message."
//        self.calculatorModel.showAlert(message: message)
//        XCTAssertNil(calculatorModel.viewController, "No alert should be presented when viewController is not set")
//    }
//
//
//}
