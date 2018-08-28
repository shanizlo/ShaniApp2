//
//  TaskCell.swift
//  ShaniApp2
//
//  Created by Shani Zlotnik on 27/08/2018.
//

import UIKit

protocol ChangeButton {
    func changeButton(checked: Bool, index: Int?)
}

class TaskCell: UITableViewCell {

    @IBOutlet weak var checkBoxOutlet: UIButton!
    
    @IBOutlet weak var taskNameLabel: UILabel!
    
    @IBAction func checkBoxAction(_ sender: Any) {
        if tasks![indexP!].checked {
            delegate?.changeButton(checked: false, index: indexP)
        } else {
            delegate?.changeButton(checked: true, index: indexP)
        }
    }
    
    var delegate: ChangeButton?
    var indexP: Int?
    var tasks: [Task]?
}
