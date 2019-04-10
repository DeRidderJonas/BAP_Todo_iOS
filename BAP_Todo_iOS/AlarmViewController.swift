//
//  SecondViewController.swift
//  BAP_Todo_iOS
//
//  Created by Jonas De Ridder on 27/03/2019.
//  Copyright © 2019 Jonas De Ridder. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController {

    let timepicker = UIDatePicker()
    var showTimepicker = false;
    
    @IBOutlet weak var alarmButton: UIButton!
    @IBAction func alarm_button(_ sender: Any) {
        if !showTimepicker {
            timepicker.datePickerMode = UIDatePicker.Mode.time
            timepicker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
            let pickerSize: CGSize = timepicker.sizeThatFits(CGSize.zero)
            timepicker.frame = CGRect(x:0.0, y:250, width:pickerSize.width, height:460)
            self.view.addSubview(timepicker)
            showTimepicker = true;
        } else {
            timepicker.removeFromSuperview()
            showTimepicker = false;
        }
    }
    @IBOutlet weak var enabledSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enabledSwitch.addTarget(self, action: #selector(self.switchValueDidChange(sender:)), for: .valueChanged)
        
        var alarm = UserDefaults.standard.string(forKey: "alarm")
        if alarm == nil {
            alarm = "none"
        }
        alarmButton.setTitle(alarm, for: .normal)
        
        let alarmEnabled = UserDefaults.standard.bool(forKey: "alarmEnabled")
        enabledSwitch.isOn = alarmEnabled;
    }

    @objc func dueDateChanged(sender: UIDatePicker){
        let dateFormatter = DateFormatter();
        dateFormatter.dateStyle = .none;
        dateFormatter.timeStyle = .short;
        let timeString = dateFormatter.string(from: sender.date)
        alarmButton.setTitle(timeString, for: .normal)
        UserDefaults.standard.set(timeString, forKey: "alarm")
    }

    @objc func switchValueDidChange(sender: UISwitch){
        UserDefaults.standard.set(sender.isOn, forKey: "alarmEnabled")
    }
}

