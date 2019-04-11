//
//  TasksListViewControllerCollectionViewController.swift
//  BAP_Todo_iOS
//
//  Created by Jonas De Ridder on 11/04/2019.
//  Copyright © 2019 Jonas De Ridder. All rights reserved.
//

import UIKit
import SQLite3

class TasksListViewControllerCollectionViewController: UICollectionViewController {

    //Mark: Properties
    private let reuseIdentifier = "TaskCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    private var tasks: [Task] = []
    
    var db: OpaquePointer?;
    
    override func viewWillAppear(_ animated: Bool) {
        tasks.removeAll();
        loadData()
        collectionView.reloadData()
    }
    
    func loadData(){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("tasks.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening db");
        }
        
        let createTableQuery = "create table if not exists task (id integer primary key autoincrement, title text, done integer, deadline text, extra text)"
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
            return;
        }
        
        let selectQuery = "select * from task"
        
        var stmt: OpaquePointer?
        
        if sqlite3_prepare(db, selectQuery, -1, &stmt, nil) != SQLITE_OK {
            let errorMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing query \(errorMsg)")
        }
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int(stmt, 0)
            let title = String(cString: sqlite3_column_text(stmt, 1))
            let doneInt = Int(sqlite3_column_int(stmt, 2))
            let deadline = String(cString: sqlite3_column_text(stmt, 3))
            let extra = String(cString: sqlite3_column_text(stmt, 4))
            tasks.insert(Task(id: Int(id), title: title, done: doneInt == 1, deadline: deadline, extra: extra), at: 0)
        }
    }
    
    //Mark: CollectionView
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TaskCollectionViewCell
        
        let currentTask = tasks[indexPath.row]
        let displayDone = currentTask.done ? "DONE" : "TODO"
        let displayText = "\(currentTask.title) (\(displayDone))"
        
        cell.taskDisplayText.text = displayText;
        cell.id = currentTask.id;
        
        return cell;
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(TasksHeaderView.self)", for: indexPath) as? TasksHeaderView else {
                fatalError("Invalid view type")
            }
            return headerView
        default:
            assert(false, "Invalid element type")
        }
    }
    
}
