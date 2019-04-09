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
    var deadline: String;
    var extra: String;
    
    init(id: Int, title: String, done: Bool, deadline: String, extra: String) {
        self.id = id;
        self.title = title;
        self.done = done;
        self.deadline = deadline;
        self.extra = extra;
    }
    
    //MARK: Types
    struct PropertyKey {
        static let id = "id"
        static let title = "title"
        static let done = "done"
        static let deadline = "deadline"
        static let extra = "extra"
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.id);
        aCoder.encode(title, forKey: PropertyKey.title);
        aCoder.encode(done, forKey: PropertyKey.done);
        aCoder.encode(deadline, forKey: PropertyKey.deadline);
        aCoder.encode(extra, forKey: PropertyKey.extra);
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: PropertyKey.id);
        let done = aDecoder.decodeBool(forKey: PropertyKey.done);
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode title for Task object", log: OSLog.default, type: .debug)
            return nil;
        }
        guard let deadline = aDecoder.decodeObject(forKey: PropertyKey.deadline) as? String else {
            os_log("Unable to decide deadline for Task object", log: OSLog.default, type: .debug)
            return nil;
        }
        guard let extra = aDecoder.decodeObject(forKey: PropertyKey.extra) as? String else {
            os_log("Unable to decide extra for Task object", log: OSLog.default, type: .debug)
            return nil;
        }
        self.init(id: id,title: title,done: done, deadline: deadline, extra: extra);
    }
}
