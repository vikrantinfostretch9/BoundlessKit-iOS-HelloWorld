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
    
    private let defaults = UserDefaults.standard
    var tasks: [Task] = []
    
    override init() {
        super.init()
        loadTasks()
    }
    
    func addTask(_ name:String, additionalText:String){
        tasks.append(Task(name: name, additionalText: additionalText))
        saveTasks()
    }
    
    func removeTask(at index: Int) {
        tasks.remove(at: index)
        saveTasks()
    }
    
    func addDemo(){
        tasks.append(Task(name: "Laundry", additionalText: "laundormat closes never"))
        tasks.append(Task(name: "Cover sheet", additionalText: "Follow TPS guidlines"))
        tasks.append(Task(name: "Feed Mr. Whiskers", additionalText: "where did mr. snek go?"))
        tasks.append(Task(name: "Run at the rec center", additionalText: "2 meters"))
        tasks.append(Task(name: "Push-ups", additionalText: "25"))
        tasks.append(Task(name: "Take over the world", additionalText: "tomorrow"))
        tasks.append(Task(name: "Make dinner", additionalText: "meatloaf"))
        tasks.append(Task(name: "Go to sleep", additionalText: "11:00pm"))
        saveTasks()
    }
    
    func saveTasks() {
        let data = NSKeyedArchiver.archivedData(withRootObject: tasks)
        defaults.set(data, forKey: "tasks")
    }
    
    func loadTasks() {
        if let data = defaults.object(forKey: "tasks") as? Data,
            let savedTasks = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Task] {
            self.tasks = savedTasks
            NSLog("Found saved tasks")
        } else {
            NSLog("Could not restore tasks")
        }
    }
    
}
