//
//  SuborbitalStage.swift
//  RocketAnalyzerLibrary
//
//  Created by John Ahrens on 11/30/14.
//  Copyright (c) 2014 John Ahrens. All rights reserved.
//

import UIKit
import Foundation

class SuborbitalStage: NSObject {
    let GRAVITY = 9.8
    let METERS = 1000.0
    let PERCENT = 100.0

    var payload: Double! // in kilograms
    var targetAltitude: Double! // in kilometers
    var averageIsp: Double! // in seconds
    var thrustDuration: Double! // in seconds
    var gravityLosses: Double! // in meters/second
    var aeroLosses: Double! // in meters/second
    var propellantRatio: Double! // entered as percent. Stored as a decimal fraction

    var propellantMass: Double! // kilograms
    var structuralMass: Double! // kilograms
    var totalMass: Double! // kilograms

    init(payload: Double?, targetAltitude: Double?, averageIsp: Double?, thrustDuration: Double?,
         gravityLosses: Double?, aeroLosses: Double?, propellantRatio: Double?) {
            self.payload = payload
            self.targetAltitude = targetAltitude
            self.averageIsp = averageIsp
            self.thrustDuration = thrustDuration
            self.gravityLosses = gravityLosses
            self.aeroLosses = aeroLosses
            self.propellantRatio = propellantRatio

            self.propellantMass = 0.0
            self.structuralMass = 0.0
            self.totalMass = self.payload + self.propellantMass + self.structuralMass
    }

    func analyzeStage() -> Bool {
        var retval = true
        // Flight duration ground to target altitude, in seconds
        let duration = sqrt(2 * self.targetAltitude * METERS / GRAVITY)
        // Maximum velocity achieved to reach target Altitude in meters/second
        let velocity = duration * GRAVITY
        // Total velocity change, including losses, in meters/second
        let deltaV = velocity + self.gravityLosses + self.aeroLosses
        // Mass ratio
        let massRatio = computeMassRatio(deltaV)

        return computeMasses(retval, massRatio: computeMassRatio(deltaV))
    }

    func computeMassRatio(deltaV: Double!) ->Double {
        return pow(M_E, deltaV / (GRAVITY * self.averageIsp))
    }

    func computeMasses(retval: Bool!, massRatio: Double!) -> Bool {

        var returnValue = retval
        if self.propellantRatio <= 0.0 || self.propellantRatio >= 100.0 {
            returnValue = false
        } else {
            let pr = self.propellantRatio / PERCENT
            let numerator = self.payload * (1 - massRatio)
            let denominator = (massRatio - 1) * (1 / pr - 1) - 1
            self.propellantMass = numerator / denominator
            self.structuralMass = (self.propellantMass * (1 / pr - 1))
            self.totalMass = self.propellantMass + self.structuralMass + self.payload
        }
        
        return returnValue
    }
}