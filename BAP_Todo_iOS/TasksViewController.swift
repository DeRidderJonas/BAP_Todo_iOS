//
//  FirstViewController.swift
//  BAP_Todo_iOS
//
//  Created by Jonas De Ridder on 27/03/2019.
//  Copyright © 2019 Jonas De Ridder. All rights reserved.
//

import UIKit
import SQLite3

class TasksViewController: UIViewController {
    
    //Mark: Properties
    var db: OpaquePointer?;
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBAction func create_task(_ sender: Any) {
        let task = Task(id: -1, title: "something", done: false)
        
        var stmt: OpaquePointer?
        let insertQuery = "insert into task (title, done) values (?,?)"
        if sqlite3_prepare(db, insertQuery, -1, &stmt, nil) != SQLITE_OK {
            print("Error binding query")
        }
        print(task.title)
        if sqlite3_bind_text(stmt, 1, task.title, -1, nil) != SQLITE_OK {
            print("Error binding name")
        }
        let number: Int = task.done ? 1 : 0
        if sqlite3_bind_int(stmt, 2, Int32(number)) != SQLITE_OK {
            print("Error binding done")
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            print("Saved succesfully")
        }
        
        let id = sqlite3_last_insert_rowid(db);
        UserDefaults.standard.set(id, forKey: "currentTaskId");
    }
    
    
    
    var task: Task = Task(id: -1, title: "testString", done: false);

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        taskTitleLabel.text = task.title;
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("tasks.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening db");
        }
        
        let createTableQuery = "create table if not exists task (id integer primary key autoincrement, title text, done integer)"
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
            return;
        }
        
        print("Everything is awesome")
    }


}

