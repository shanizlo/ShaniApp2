//
//  TaskCell.swift
//  ShaniApp2
//
//  Created by Shani Zlotnik on 27/08/2018.
//

import UIKit

protocol TaskCellDelegate: class {
    func changeCompletedButtonTap(_ cell: TaskCell)
    func deleteTaskButtonTap(_ cell: TaskCell)
}

class TaskCell: UITableViewCell {

    weak var taskCellDelegate: TaskCellDelegate?
    
    @IBOutlet weak var checkBoxOutlet: UIButton!
        
    @IBOutlet weak var taskNameLabel: UILabel!
    
    @IBAction func checkBoxAction(_ sender: Any) {
        taskCellDelegate?.changeCompletedButtonTap(self)
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        taskCellDelegate?.deleteTaskButtonTap(self)
    }
    
    var indexP: Int?
}
