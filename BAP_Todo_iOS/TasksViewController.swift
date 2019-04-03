//
//  FirstViewController.swift
//  BAP_Todo_iOS
//
//  Created by Jonas De Ridder on 27/03/2019.
//  Copyright © 2019 Jonas De Ridder. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController {
    
    //Mark: Properties
    @IBOutlet weak var taskTitleLabel: UILabel!
    
    
    var task: Task = Task(id: -1, title: "testString", done: false);

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        taskTitleLabel.text = task.title;
    }


}

