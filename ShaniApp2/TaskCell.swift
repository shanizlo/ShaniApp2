//
//  TaskCell.swift
//  ShaniApp2
//
//  Created by Shani Zlotnik on 27/08/2018.
//

import UIKit

protocol TaskCellDelegate: class {
    func changeButton(_ cell: TaskCell)
    func deleteTaskButton(_ cell: TaskCell)
}

class TaskCell: UITableViewCell {

    weak var taskCellDelegate: TaskCellDelegate?
    
    var changeButtonCompletion: (() -> Void)?
    
    var deleteTaskCompletion: (() -> Void)?
    
    @IBOutlet weak var checkBoxOutlet: UIButton!
    
    @IBOutlet weak var deleteOutlet: UIButton!
    
    @IBOutlet weak var taskNameLabel: UILabel!
    
    @IBOutlet weak var taskCellRow: UIView!
    
    @IBAction func checkBoxAction(_ sender: Any) {
        taskCellDelegate?.changeButton(self)
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        taskCellDelegate?.deleteTaskButton(self)
    }
    
    var indexP: Int?
}
