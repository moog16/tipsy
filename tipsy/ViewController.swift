//
//  ViewController.swift
//  tipsy
//
//  Created by Matthew Goo on 7/29/15.
//  Copyright (c) 2015 mattgoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var billLabel: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var settingsIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let date = NSDate()
        
        if let lastUpdatedDate = defaults.objectForKey("lastUpdatedDate") as! NSDate? {
            
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.CalendarUnitMinute, fromDate: lastUpdatedDate, toDate: date, options: nil)
            let minutes = components.minute
            var hasDefault = false;
            
            if minutes <= 10 {
                if let previousBillLabel = defaults.stringForKey("billAmount") {
                    billLabel.text = previousBillLabel
                    hasDefault = true
                }
                if let previousTipLabel = defaults.stringForKey("tipAmount") {
                    tipLabel.text = previousTipLabel
                    hasDefault = true
                }
                
                if hasDefault {
                    onBillAmountEdit(self)
                }
            } else if let defaultTipRateIndex = defaults.integerForKey("defaultTipRateIndex") as Int? {
                tipControl.selectedSegmentIndex = defaultTipRateIndex
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onBillAmountEdit(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        var billAmountText = billLabel.text
        var billAmount = (billAmountText as NSString).doubleValue
        
        var tipPercentages = [0.15, 0.18, 0.2, 0.22]
        var tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        var tipAmount = billAmount * tipPercentage
        var totalAmount = billAmount + tipAmount
        
        tipLabel.text = String(format: "$%.2f", tipAmount)
        totalLabel.text = String(format: "$%.2f", totalAmount)
        
        defaults.setObject(billAmountText, forKey: "billAmount")
        defaults.setObject(NSDate(), forKey: "lastUpdatedDate")
        
        

    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func settingsButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("settingsPanel", sender: self)
    }
}

