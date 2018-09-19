//
//  TaskCell.swift
//  ShaniApp2
//
//  Created by Shani Zlotnik on 27/08/2018.
//

import UIKit

protocol ChangeButtonDelegate: class {
    func changeButton(_ cell: TaskCell)
}

class TaskCell: UITableViewCell {
    
    weak var changeButtonDelegate: ChangeButtonDelegate?
    
    var changeButtonCompletion: (() -> Void)?
    
    @IBOutlet weak var checkBoxOutlet: UIButton!
    
    @IBOutlet weak var taskNameLabel: UILabel!
    
    @IBOutlet weak var taskCellRow: UIView!
    
    @IBAction func checkBoxAction(_ sender: Any) {
        
        changeButtonDelegate?.changeButton(self)
 
    }
    
    var indexP: Int?
//    var tasksArr: [TaskTodo]?
}
