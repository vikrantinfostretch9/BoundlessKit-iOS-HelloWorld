//
//  Task.swift
//  To Do List
//
//  Created by Akash Desai on 6/8/16.
//  Copyright © 2016 DopamineLabs. All rights reserved.
//

import UIKit

@objc(Task)
class Task: NSObject, NSCoding {
    var name: String
    var additionalText: String
    
    required init(name:String, additionalText:String){
        self.name = name
        self.additionalText = additionalText
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let n = aDecoder.decodeObject(forKey: "name") as! String
        let at = aDecoder.decodeObject(forKey: "additionalText") as! String
        self.init(name: n, additionalText: at)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(additionalText, forKey: "additionalText")
    }
}
