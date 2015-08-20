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
    @IBOutlet weak var totalUIScreen: UIView!
    
    var hasScreenLifted = false
    let themes = [
        "lightThemeColor": UIColor(
                red: 55/225,
                green: 152/255,
                blue: 1,
                alpha: 1
            ),
        "darkThemeColor": UIColor(
            red: 1,
            green: 156/255,
            blue: 105/255,
            alpha: 1
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let lastUpdatedDate = defaults.objectForKey("lastUpdatedDate") as! NSDate? {
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.CalendarUnitMinute, fromDate: lastUpdatedDate, toDate: date, options: nil)
            let minutes = components.minute
            setLocale()
            
            if let defaultTipRateIndex = defaults.integerForKey("defaultTipRateIndex") as Int? {
                tipControl.selectedSegmentIndex = defaultTipRateIndex
            }
            
            if minutes <= 1 {
                if let previousBillLabel = defaults.stringForKey("billAmount") {
                    if count(previousBillLabel) > 0 {
                        billLabel.text = previousBillLabel
                        if let previousTipIndex = defaults.integerForKey("tipAmountIndex") as Int? {
                            tipControl.selectedSegmentIndex = previousTipIndex
                            onBillAmountEdit(self)
                        }
                    }
                }
            }
        }
        
        setColorSchemaAndSetBackground()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "backToMainView",
            name: UIApplicationDidBecomeActiveNotification,
            object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        billLabel.becomeFirstResponder()
        updateScreenHeight()
        setColorSchemaAndSetBackground()
    }
    
    func shiftScreenUp() {
        if !hasScreenLifted {
            self.view.frame.origin.y -= 150
            hasScreenLifted = true
        }
    }
    
    func shiftScreenDown() {
        if hasScreenLifted {
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
        count(billLabel.text) > 0 ? shiftScreenUp() : shiftScreenDown()
    }
    
    func setColorSchemaAndSetBackground() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let isLightTheme = defaults.boolForKey("isLightTheme") as Bool? {
            let color = isLightTheme ? themes["lightThemeColor"] : themes["darkThemeColor"]
            totalUIScreen.backgroundColor = color
            tipControl.tintColor = color
            billLabel.textColor = color

        } else {
            defaults.setBool(true, forKey: "isLightTheme")
        }
    }
    
    func calculateTip(billAmount: Double, tipIndex: Int) -> Double {
        let tipPercentages = [0.15, 0.18, 0.2, 0.22]
        var tipPercentage = tipPercentages[tipIndex]
        var tipAmount = billAmount * tipPercentage
        return tipAmount
    }
    
    @objc func backToMainView() {
        setLocale()
        setColorSchemaAndSetBackground()
    }
    
    func setLocale() {
        let currencySymbol = NSNumberFormatter().currencySymbol
        tipLabel.text = currencySymbol
        totalLabel.text = currencySymbol
        billLabel.placeholder = currencySymbol
    }

    @IBAction func onBillAmountFocus(sender: AnyObject) {
        updateScreenHeight()
    }
    
    @IBAction func onBillAmountEdit(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        var billAmountText = billLabel.text
        var billAmount = (billAmountText as NSString).doubleValue
        var tipAmount = calculateTip(billAmount, tipIndex: tipControl.selectedSegmentIndex)
        var totalAmount = billAmount + tipAmount
        
        tipLabel.text = formatCurrency(tipAmount)
        totalLabel.text = formatCurrency(totalAmount)
        
        defaults.setObject(billAmountText, forKey: "billAmount")
        defaults.setInteger(tipControl.selectedSegmentIndex, forKey: "tipAmountIndex")
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

