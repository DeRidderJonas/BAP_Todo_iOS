//
//  SecondViewController.swift
//  BAP_Todo_iOS
//
//  Created by Jonas De Ridder on 27/03/2019.
//  Copyright © 2019 Jonas De Ridder. All rights reserved.
//

import UIKit
import CoreLocation

class AlarmViewController: UIViewController, CLLocationManagerDelegate {

    let timepicker = UIDatePicker()
    var showTimepicker = false;
    var locationManager: CLLocationManager!;
    
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
    @IBOutlet weak var locationText: UILabel!
    @IBAction func location_button(_ sender: Any) {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    
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

    //Mark: LocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        
        var text = ""
        
        let url = URL(string: "https://api.timezonedb.com/v2.1/get-time-zone?key=BNC3MFRJAMK4&format=json&fields=abbreviation,formatted&by=position&lat=\(userLocation.coordinate.latitude)&lng=\(userLocation.coordinate.longitude)")
        let request = URLSession.shared.dataTask(with: url!){ (data, response, error) in
            if error == nil {
                let response = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                text = response! as String
                do {
                    let jsonResult: Dictionary<String, String> = try JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, String>
                    text = "Timezone: \(jsonResult["abbreviation"] ?? "") time: \(jsonResult["formatted"] ?? "")"
                } catch let parsingError {
                    print("Error", parsingError)
                }
                
                
            }
        }
        request.resume()
        sleep(5)
        locationText.text = text
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}

