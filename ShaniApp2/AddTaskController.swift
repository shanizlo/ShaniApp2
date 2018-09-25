//
//  AddTaskController.swift
//  ShaniApp2
//
//  Created by Shani Zlotnik on 27/08/2018.
//


import UIKit

protocol AddTaskDelegate: class {
    func taskAdded(name: String)
}

class AddTaskController: UIViewController {
    
    weak var addTaskDelegate: AddTaskDelegate?
    var postNewTaskCompletion: (() -> Void)?
    @IBOutlet weak var taskNameOutlet: UITextField!
    
    @IBAction func addAction(_ sender: Any) {
        if taskNameOutlet.text != "" {
            addTaskDelegate?.taskAdded(name: taskNameOutlet.text!)
        }
    }
    
}
