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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onBillAmountEdit(sender: AnyObject) {
        var billAmountText = billLabel.text
        var billAmount = (billAmountText as NSString).doubleValue
        var tipPercentages = [0.15, 0.18, 0.2, 0.22]
        var tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        var tipAmount = billAmount * tipPercentage
        var totalAmount = billAmount + tipAmount
        
        tipLabel.text = String(format: "$%.2f", tipAmount)
        totalLabel.text = String(format: "$%.2f", totalAmount)
        

    }
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }

}

