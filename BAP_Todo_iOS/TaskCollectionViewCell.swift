//
//  TaskCollectionViewCell.swift
//  BAP_Todo_iOS
//
//  Created by Jonas De Ridder on 11/04/2019.
//  Copyright © 2019 Jonas De Ridder. All rights reserved.
//

import UIKit

class TaskCollectionViewCell: UICollectionViewCell {
    
    var id: Int = 0;
    
    @IBOutlet weak var taskDisplayText: UILabel!
    @IBAction func active_button(_ sender: Any) {
        print("setting active \(id)")
        UserDefaults.standard.set(id, forKey: "currentTaskId")
    }
}
