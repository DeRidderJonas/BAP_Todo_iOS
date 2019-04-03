//
//  TaskDetailViewController.swift
//  BAP_Todo_iOS
//
//  Created by Jonas De Ridder on 03/04/2019.
//  Copyright © 2019 Jonas De Ridder. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController, UITextFieldDelegate {
    
    //Mark: Properties
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDoneSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    
    var task: Task = Task(id: -1, title: "", done: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        taskTitleTextField.delegate = self;
        taskDoneSwitch.addTarget(self, action: #selector(self.switchValueDidChange(sender:)), for: .valueChanged)
    }
    
    //Mark: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        task.title = taskTitleTextField.text ?? "";
    }
    
    //Mark: UISwitch
    @objc func switchValueDidChange(sender: UISwitch) {
        print(sender.isOn)
    }
}
