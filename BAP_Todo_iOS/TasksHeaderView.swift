//
//  TasksHeaderView.swift
//  BAP_Todo_iOS
//
//  Created by Jonas De Ridder on 11/04/2019.
//  Copyright © 2019 Jonas De Ridder. All rights reserved.
//

import UIKit
import SQLite3

class TasksHeaderView: UICollectionReusableView {
    
    var db: OpaquePointer?;
    internal let SQL_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    @IBAction func create_button(_ sender: Any) {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("tasks.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening db");
        }
        
        let createTableQuery = "create table if not exists task (id integer primary key autoincrement, title text, done integer, deadline text, extra text)"
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
            return;
        }
        
        let task = Task(id: -1, title: "something", done: false, deadline: "never", extra: "nothing")
        
        
        var stmt: OpaquePointer?
        let insertQuery = "insert into task (title, done, deadline, extra) values (?,?,?,?)"
        if sqlite3_prepare(db, insertQuery, -1, &stmt, nil) != SQLITE_OK {
            print("Error binding query")
        }
        
        if sqlite3_bind_text(stmt, 1, task.title, -1, SQL_TRANSIENT) != SQLITE_OK {
            print("Error binding name")
        }
        let number: Int = task.done ? 1 : 0
        if sqlite3_bind_int(stmt, 2, Int32(number)) != SQLITE_OK {
            print("Error binding done")
        }
        
        if sqlite3_bind_text(stmt, 3, task.deadline, -1, SQL_TRANSIENT) != SQLITE_OK {
            print("Error binding deadline")
        }
        
        if sqlite3_bind_text(stmt, 4, task.extra, -1, SQL_TRANSIENT) != SQLITE_OK {
            print("Error binding extra")
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            print("Saved succesfully")
        }
        
        let id = sqlite3_last_insert_rowid(db);
        UserDefaults.standard.set(id, forKey: "currentTaskId");
    }
}
