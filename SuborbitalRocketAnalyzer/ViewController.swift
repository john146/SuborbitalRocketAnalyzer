//
//  ViewController.swift
//  SuborbitalRocketAnalyzer
//
//  Created by John Ahrens on 11/29/14.
//  Copyright (c) 2014 John Ahrens. All rights reserved.
//

import UIKit

extension Double {
    func format(f: String) ->String {
        return NSString(format: "%\(f)f", self)
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var payloadInput: UITextField!
    @IBOutlet weak var targetAltitudeInput: UITextField!
    @IBOutlet weak var averageIspInput: UITextField!
    @IBOutlet weak var thrustDurationInput: UITextField!
    @IBOutlet weak var gravityLossesInput: UITextField!
    @IBOutlet weak var aeroLossesInput: UITextField!
    @IBOutlet weak var propellantRatioLabel: UILabel!
    @IBOutlet weak var propellantRatioInput: UISlider!
    @IBOutlet weak var payloadMass: UILabel!
    @IBOutlet weak var structuralMass: UILabel!
    @IBOutlet weak var propellantMass: UILabel!
    @IBOutlet weak var liftoffMass: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        propellantRatioLabel.text = "80%"
        payloadMass.text = "Payload Mass:"
        structuralMass.text = "Structural Mass:"
        propellantMass.text = "Propellant Mass:"
        liftoffMass.text = "Gross Liftoff Mass:"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func propellantRatioChanged(sender: UISlider) {
        let pr = lroundf(sender.value)
        propellantRatioLabel.text = "\(pr)%"
    }

    @IBAction func backgroundTab(sender: UIControl) {
        payloadInput.resignFirstResponder()
        targetAltitudeInput.resignFirstResponder()
        averageIspInput.resignFirstResponder()
        thrustDurationInput.resignFirstResponder()
        gravityLossesInput.resignFirstResponder()
        aeroLossesInput.resignFirstResponder()
    }

    @IBAction func calculatePerformance(sender: UIButton) {
        self.backgroundTab(sender)
        let payload = (self.payloadInput.text as NSString).doubleValue
        let altitude = (self.targetAltitudeInput.text as NSString).doubleValue
        let isp = (self.averageIspInput.text as NSString).doubleValue
        let burnTime = (self.thrustDurationInput.text as NSString).doubleValue
        let gloss = (self.gravityLossesInput.text as NSString).doubleValue
        let aloss = (self.aeroLossesInput.text as NSString).doubleValue
        let pr = Double(propellantRatioInput.value)
        
        let analyzer = SuborbitalStage(payload: payload, targetAltitude: altitude, averageIsp: isp,
                                thrustDuration: burnTime, gravityLosses: gloss, aeroLosses: aloss,
                               propellantRatio: pr)
        if analyzer.analyzeStage() {
            let doubleFormat = "0.2"
            payloadMass.text = "Payload Mass: \(analyzer.payload.format(doubleFormat)) kilograms"
            structuralMass.text = "Structural Mass: \(analyzer.structuralMass.format(doubleFormat)) kilograms"
            propellantMass.text = "Propellant Mass: \(analyzer.propellantMass.format(doubleFormat)) kilograms"
            liftoffMass.text = "Gross Liftoff Mass: \(analyzer.totalMass.format(doubleFormat)) kilograms"
        } else {
            // TODO: Handle failure
        }
    }

}

