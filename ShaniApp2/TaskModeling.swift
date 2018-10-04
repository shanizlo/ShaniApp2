//
//  TaskModeling.swift
//  ShaniApp2
//
//  Created by Shani Zlotnik on 03/10/2018.
//

import Foundation

class TaskModeling {
    
    func jsonToArrayOfTasksSorted(json: Data) -> [TaskTodo] {
        var arrOfTasks: [TaskTodo] = []
        do {
            arrOfTasks = try JSONDecoder().decode([TaskTodo].self, from: json)
            arrOfTasks.sort { $0.completed && !$1.completed }
        } catch {
            print(error.localizedDescription)
        }
        return arrOfTasks
    }
    
    
    struct TaskTodo: Codable {
        var id = 0
        var title = ""
        var completed = false
    }
    
}
