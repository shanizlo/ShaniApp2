//
//  AddTaskController.swift
//  ShaniApp2
//
//  Created by Shani Zlotnik on 27/08/2018.
//

import UIKit

protocol AddTask {
    func addTask(name: String)
}

class AddTaskController: UIViewController {
    
    var delegate: AddTask?

    @IBOutlet weak var taskNameOutlet: UITextField!
    
    @IBAction func addAction(_ sender: Any) {
        if taskNameOutlet.text != "" {
            delegate?.addTask(name: taskNameOutlet.text!)
            navigationController?.popViewController(animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
