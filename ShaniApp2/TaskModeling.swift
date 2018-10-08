//
//  TaskModeling.swift
//  ShaniApp2
//
//  Created by Shani Zlotnik on 03/10/2018.
//

import Foundation

class TaskModeling {
    
    func dataToArrayOfTasksSorted(jsonData: Data) -> [TaskTodo] {

        guard var arrOfTasks = try? JSONDecoder().decode([TaskTodo].self, from: jsonData) else { return [] }
        arrOfTasks.sort { $0.completed && !$1.completed }
        return arrOfTasks
    }
    
    
    struct TaskTodo: Codable {
        var id = 0
        var title = ""
        var completed = false
    }
    
}
