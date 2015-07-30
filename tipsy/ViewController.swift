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
    
    var hasScreenLifted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        billLabel.becomeFirstResponder()
        
        if let lastUpdatedDate = defaults.objectForKey("lastUpdatedDate") as! NSDate? {
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.CalendarUnitMinute, fromDate: lastUpdatedDate, toDate: date, options: nil)
            let minutes = components.minute
            var hasDefault = false
            
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
                setLocale()
            } else {
                setLocale()
            }
        }
        
        if let previousHasScreenLifted = defaults.boolForKey("previousHasScreenLifted") as Bool? {
            hasScreenLifted = previousHasScreenLifted
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("\(hasScreenLifted)")
        updateScreenHeight()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func savePreviousHasScreenLifted(hasScreenLifted: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(hasScreenLifted, forKey: "previousHasScreenLifted")
    }
    
    func shiftScreenUp() {
        if !hasScreenLifted {
            println("showKeyboard")
            self.view.frame.origin.y -= 150
            hasScreenLifted = true
        }
    }
    
    func shiftScreenDown() {
        if hasScreenLifted {
            println("hideKeyboard")
            self.view.frame.origin.y += 150
            hasScreenLifted = false
        }
    }
    
    func formatCurrency(amount: Double) -> String {
        var formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        return formatter.stringFromNumber(amount)!
    }
    
    func updateScreenHeight() {
        if count(billLabel.text) > 0 {
            shiftScreenUp()
        } else {
            shiftScreenDown()
        }
    }
    
    func setLocale() {
        let currencySymbol = NSNumberFormatter().currencySymbol
        tipLabel.text = currencySymbol
        totalLabel.text = currencySymbol
        billLabel.placeholder = currencySymbol
        
    }

    @IBAction func onBillAmountEdit(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        var billAmountText = billLabel.text
        var billAmount = (billAmountText as NSString).doubleValue
        
        var tipPercentages = [0.15, 0.18, 0.2, 0.22]
        var tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        var tipAmount = billAmount * tipPercentage
        var totalAmount = billAmount + tipAmount
        
        tipLabel.text = formatCurrency(tipAmount)
        totalLabel.text = formatCurrency(totalAmount)
        
        defaults.setObject(billAmountText, forKey: "billAmount")
        defaults.setObject(billAmountText, forKey: "billAmount")
        defaults.setObject(NSDate(), forKey: "lastUpdatedDate")
        
        if sender !== tipControl && sender !== self {
            updateScreenHeight()
        }

        billLabel.placeholder = NSNumberFormatter().currencySymbol

    }
    
    @IBAction func onTap(sender: AnyObject) {
        if hasScreenLifted {
            shiftScreenDown()
        }
        view.endEditing(true)
    }
    
    @IBAction func settingsButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("settingsModal", sender: self)
    }
}

