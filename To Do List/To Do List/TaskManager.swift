//
//  TaskManager.swift
//  To Do List
//
//  Created by Akash Desai on 6/7/16.
//  Copyright © 2016 DopamineLabs. All rights reserved.
//

import UIKit

var taskManager:TaskManager = TaskManager()

class TaskManager: NSObject {
    
    var tasks = Array<Task>()
    
    func addTask(_ name:String, additionalText:String){
        tasks.append(Task(name: name, additionalText: additionalText))
    }
    
    func addDemo(){
        tasks.append(Task(name: "Laundry", additionalText: "laundormat closes at 9pm"))
        tasks.append(Task(name: "Cover sheet", additionalText: "Follow TPS guidlines"))
        tasks.append(Task(name: "Feed Mr. Whiskers", additionalText: "kibble bits for days"))
        tasks.append(Task(name: "Run at the rec center", additionalText: "2 miles"))
    }
    
}
