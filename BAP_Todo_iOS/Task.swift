//
//  Task.swift
//  BAP_Todo_iOS
//
//  Created by Jonas De Ridder on 03/04/2019.
//  Copyright © 2019 Jonas De Ridder. All rights reserved.
//

import Foundation
import os.log

class Task: NSObject, NSCoding {
    
    //MARK: Properties
    var id: Int;
    var title: String;
    var done: Bool;
    
    init(id: Int, title: String, done: Bool) {
        self.id = id;
        self.title = title;
        self.done = done;
    }
    
    //MARK: Types
    struct PropertyKey {
        static let id = "id"
        static let title = "title"
        static let done = "done"
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.id);
        aCoder.encode(title, forKey: PropertyKey.title);
        aCoder.encode(done, forKey: PropertyKey.done);
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: PropertyKey.id);
        let done = aDecoder.decodeBool(forKey: PropertyKey.done);
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode title for Task object", log: OSLog.default, type: .debug)
            return nil;
        }
        self.init(id: id,title: title,done: done);
    }
}
