//
//  SuborbitalAnalyzer.swift
//  SuborbitalRocketAnalyzer
//
//  Created by John Ahrens on 11/30/14.
//  Copyright (c) 2014 John Ahrens. All rights reserved.
//

import UIKit
import XCTest

import SuborbitalRocketAnalyzer

class SuborbitalAnalyzer: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /**
    * Test stage analysis assuming starting at sea-level, 0 velocity and attempting to lift 10 kilograms to
    * 100 kilometers. Our rocket engine ISP is 245 seconds, will burn for 40 seconds, losing 393 m/s to gravity and
    * 640 m/s to aerodynamic drag. Propellent ratio is 80%.
    *
    * Expect a result of Mass lofted of 10 kilograms, Mass of propellant of 31.2 kilograms and a structural mass
    * of 7.8 kilograms.
    */
    func testAnalyzeStageTo100Km() {
        let payload = 10.0 // kilograms
        let targetAltitude = 100.0 // kilometers
        let averageIsp = 245.0 // seconds
        let thrustDuration = 40.0 // seconds
        let gravityLoss = 393.0 // meters/second
        let aeroLoss = 640.0 // meters/second
        let propellantRatio = 80.0 // Percent

        let ss = SuborbitalStage(payload: payload, targetAltitude: targetAltitude, averageIsp: averageIsp,
                                 thrustDuration: thrustDuration, gravityLosses: gravityLoss, aeroLosses: aeroLoss,
                                 propellantRatio: propellantRatio)
        XCTAssertNotNil(ss, "No SuborbitalStage constructed")
        XCTAssertTrue(ss.analyzeStage(), "Failed to successfully analyze stage")
        XCTAssertEqualWithAccuracy(ss.payload, 10.0, 0.01,
                                   "Expected 10 kilograms of payload, but got \(ss.payload)")
        XCTAssertEqualWithAccuracy(ss.structuralMass, 7.8, 0.1,
                                   "Expected 7.8 kilograms of structure, but got \(ss.structuralMass)")
        XCTAssertEqualWithAccuracy(ss.propellantMass, 31.2, 0.1,
                                   "Expected 31.2 kilograms of propellant, but got \(ss.propellantMass)")
        XCTAssertEqualWithAccuracy(ss.totalMass, 49.0, 0.1,
                                   "Expected 49 kilograms of total mass, but got \(ss.totalMass)")
    }

    /**
    * Test stage analysis assuming starting at sea-level, 0 velocity and attempting to lift 10 kilograms to
    * 65 kilometers. Our rocket engine ISP is 245 seconds, will burn for 40 seconds, losing 393 m/s to gravity and
    * 640 m/s to aerodynamic drag. Propellant ratio is 80%.
    *
    * Expect a result of Mass lofted of 10 kilograms, Mass of propellant of 23.0 kilograms and a structural mass
    * of 5.75 kilograms.
    */
    func testAnalyzeStageTo65Km() {
        let payload = 10.0 // kilograms
        let targetAltitude = 65.0 // kilometers
        let averageIsp = 245.0 // seconds
        let thrustDuration = 40.0 // seconds
        let gravityLoss = 393.0 // meters/second
        let aeroLoss = 640.0 // meters/second
        let propellantRatio = 80.0 // percent

        let ss = SuborbitalStage(payload: payload, targetAltitude: targetAltitude, averageIsp: averageIsp,
                                 thrustDuration: thrustDuration, gravityLosses: gravityLoss, aeroLosses: aeroLoss,
                                 propellantRatio: propellantRatio)
        XCTAssertNotNil(ss, "Failed to successfully initialize stage")
        XCTAssertTrue(ss.analyzeStage(), "Failed to successfully analyze stage")
        XCTAssertEqualWithAccuracy(ss.payload, 10.0, 0.1, "Expected 10 kilograms of payload, but got \(ss.payload)")
        XCTAssertEqualWithAccuracy(ss.propellantMass, 23.0, 0.1,
                                   "Expected 23 kilograms of propellant, but got \(ss.propellantMass)")
        XCTAssertEqualWithAccuracy(ss.structuralMass, 5.75, 0.05,
                                   "Expected 5.75 kilograms of structure, but got \(ss.structuralMass)")
        XCTAssertEqualWithAccuracy(ss.totalMass, 38.75, 0.05,
                                   "Expected 38.75 kilograms total mass, but got \(ss.totalMass)")
    }

    /**
    * Test propellant ratio of 0.0. Since this would set up a divide by zero situation, we need to make sure that this
    * is handled properly. There are thee places to handle it. In the constructor, in the setter, and in the
    * analyzeStage() method where it gets used. This is in all cases a nonsense value.
    */
    func testSetPropellantRatioToZero() {
        let payload = 10.0 // kilograms
        let targetAltitude = 65.0 // kilometers
        let averageIsp = 245.0 // seconds
        let thrustDuration = 40.0 // seconds
        let gravityLoss = 393.0 // meters/second
        let aeroLoss = 640.0 // meters/second
        let propellantRatio = 0.0 // percent

        let ss = SuborbitalStage(payload: payload, targetAltitude: targetAltitude, averageIsp: averageIsp,
                                 thrustDuration: thrustDuration, gravityLosses: gravityLoss, aeroLosses: aeroLoss,
                                 propellantRatio: propellantRatio)
        XCTAssertNotNil(ss, "Failed to successfully initialize stage")
        XCTAssertFalse(ss.analyzeStage(), "Success in analyzing stage. Should have failed")
    }

    /**
    * Test propellant ratio of 1.0 (or 100%). Since this would be a value that makes no sense, and in some cases may
    * create a divide by zero issue, we are ensuring a failure when this is the value.
    */
    func testSetPropellantRatioTo100Percent() {
        let payload = 10.0 // kilograms
        let targetAltitude = 65.0 // kilometers
        let averageIsp = 245.0 // seconds
        let thrustDuration = 40.0 // seconds
        let gravityLoss = 393.0 // meters/second
        let aeroLoss = 640.0 // meters/second
        let propellantRatio = 100.0 // percent

        let ss = SuborbitalStage(payload: payload, targetAltitude: targetAltitude, averageIsp: averageIsp,
            thrustDuration: thrustDuration, gravityLosses: gravityLoss, aeroLosses: aeroLoss,
            propellantRatio: propellantRatio)
        XCTAssertNotNil(ss, "Failed to successfully initialize stage")
        XCTAssertFalse(ss.analyzeStage(), "Success in analyzing stage. Should have failed")
    }

}
