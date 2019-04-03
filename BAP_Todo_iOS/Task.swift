//
//  Task.swift
//  BAP_Todo_iOS
//
//  Created by Jonas De Ridder on 03/04/2019.
//  Copyright © 2019 Jonas De Ridder. All rights reserved.
//

import Foundation

class Task {
    var id: Int;
    var title: String;
    var done: Bool;
    
    init(id: Int, title: String, done: Bool) {
        self.id = id;
        self.title = title;
        self.done = done;
    }
}
