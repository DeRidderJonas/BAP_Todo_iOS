//
//  TaskDetailViewController.swift
//  BAP_Todo_iOS
//
//  Created by Jonas De Ridder on 03/04/2019.
//  Copyright © 2019 Jonas De Ridder. All rights reserved.
//

import UIKit
import SQLite3

class TaskDetailViewController: UIViewController, UITextFieldDelegate {
    
    //Mark: Properties
    var db: OpaquePointer?;
    var task: Task = Task(id: -1, title: "placeholder", done: false, deadline: "placeholder", extra: "placeholder")
    var currentTaskId: Int = -1;
    internal let SQL_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDoneSwitch: UISwitch!
    @IBAction func button_save(_ sender: Any) {
        var stmt: OpaquePointer?
        let insertQuery = "update task set title = ?, done = ?, deadline = ?, extra = ? where id = ?"
        if sqlite3_prepare(db, insertQuery, -1, &stmt, nil) != SQLITE_OK {
            print("Error binding query")
        }
        
        print("binding title: \(task.title)")
        if sqlite3_bind_text(stmt, 1, task.title, -1, SQL_TRANSIENT) != SQLITE_OK {
            print("Error binding name")
        }
        let number: Int = task.done ? 1 : 0;
        
        if sqlite3_bind_int(stmt, 2, Int32(number)) != SQLITE_OK {
            print("Error binding done")
        }
        
        if sqlite3_bind_text(stmt, 3, task.deadline, -1, SQL_TRANSIENT) != SQLITE_OK {
            print("Error binding deadline")
        }
        
        if sqlite3_bind_text(stmt, 4, task.extra, -1, SQL_TRANSIENT) != SQLITE_OK {
            print("Error binding extra")
        }
        
        if sqlite3_bind_int(stmt, 5, Int32(currentTaskId)) != SQLITE_OK {
            print("Error binding task id")
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            print("Updated succesfully for id \(task.id)")
        }
    }
    @IBOutlet weak var deadlineButton: UIButton!
    @IBAction func deadline_button(_ sender: Any) {
        print("deadline button pressed")
    }
    @IBOutlet weak var extraButton: UIButton!
    @IBAction func extra_button(_ sender: Any) {
        print("extra button pressed")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        taskTitleTextField.delegate = self;
        taskDoneSwitch.addTarget(self, action: #selector(self.switchValueDidChange(sender:)), for: .valueChanged)
        
        currentTaskId = UserDefaults.standard.integer(forKey: "currentTaskId")
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("tasks.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening db");
        }
        
        
        
        let createTableQuery = "create table if not exists task (id integer primary key autoincrement, title text, done integer, deadline text, extra text)"
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
            return;
        }
        
        let queryString = "select * from task where id = ?";
        var stmt: OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errorMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing query \(errorMsg)")
        }
        
        if sqlite3_bind_int(stmt, 1, Int32(currentTaskId)) != SQLITE_OK {
            print("Error binding currentTaskId")
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let title = String(cString: sqlite3_column_text(stmt, 1))
            let doneInt = Int(sqlite3_column_int(stmt, 2))
            let deadline = String(cString: sqlite3_column_text(stmt, 3))
            let extra = String(cString: sqlite3_column_text(stmt, 4))
            
            task.id = Int(id);
            task.title = title;
            task.done = doneInt == 1;
            task.deadline = deadline;
            task.extra = extra;
        }
        
        taskTitleTextField.text = task.title;
        taskDoneSwitch.isOn = task.done;
        deadlineButton.setTitle(task.deadline, for: .normal)
        extraButton.setTitle(task.extra, for: .normal)
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
        task.done = sender.isOn;
    }
}
