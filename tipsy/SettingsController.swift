//
//  ViewController.swift
//  tipsy
//
//  Created by Matthew Goo on 7/29/15.
//  Copyright (c) 2015 mattgoo. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
    @IBOutlet weak var defaultTipControl: UISegmentedControl!
    @IBOutlet weak var themeSwitch: UISwitch!
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
        if let defaultTipRateIndex = defaults.integerForKey("defaultTipRateIndex") as Int? {
            defaultTipControl.selectedSegmentIndex = defaultTipRateIndex
        }
        if let isLightTheme = defaults.boolForKey("isLightTheme") as Bool? {
            themeSwitch.setOn(isLightTheme, animated: false)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        changeUserTheme()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onDefaultTipChanged(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        var defaultTipRateIndex = defaultTipControl.selectedSegmentIndex
        defaults.setInteger(defaultTipRateIndex, forKey: "defaultTipRateIndex")
    }
  
    @IBAction func onBackPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func onThemeSwitchChanged(sender: AnyObject) {
        changeUserTheme()
    }
    
    func changeUserTheme () {
        let lightTheme = themeSwitch.on
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(lightTheme, forKey: "isLightTheme")
        if lightTheme {
            self.view.backgroundColor = themes["lightThemeColor"]
        } else {
            self.view.backgroundColor = themes["darkThemeColor"]
        }
    }
}

