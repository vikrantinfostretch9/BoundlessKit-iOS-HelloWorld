//
//  Task.swift
//  To Do List
//
//  Created by Akash Desai on 6/8/16.
//  Copyright © 2016 DopamineLabs. All rights reserved.
//

import UIKit

class Task: NSObject {
    var name = "unnamed"
    var additionalText = "no descrioption"
    
    required init(name:String, additionalText:String){
        self.name = name
        self.additionalText = additionalText
    }

}
