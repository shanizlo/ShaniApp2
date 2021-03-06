//
//  ViewController.swift
//  ShaniApp2
//
//  Created by Shani Zlotnik on 27/08/2018.
//

import UIKit

class TodoListVC: UITableViewController, AddTaskDelegate, TaskCellDelegate {
    
    let networking = Networking()
    var tasksTodo: [Networking.TaskTodo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networking.loadDataFromCache()
        self.tasksTodo = (self.networking.tasksTodoArray)
        self.tableView.reloadData()
        print("view loaded from cache")
        networking.getJsonFromUrl(completion: { [weak self] in
           self?.tasksTodo = (self?.networking.tasksTodoArray)!
           self?.tableView.reloadData()
            print("view reloaded from get")
       })
    }
    
    func reloadList() {
        super.viewDidLoad()
        networking.getJsonFromUrl(completion: { [weak self] in
            self?.tasksTodo = (self?.networking.tasksTodoArray)!
            self?.tableView.reloadData()
            print("view reloaded from get")
        })
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksTodo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell" , for: indexPath) as! TaskCell
        
        cell.taskNameLabel.text = tasksTodo[indexPath.item].title

        if tasksTodo[indexPath.row].completed {
            cell.checkBoxOutlet.setTitle("✓", for: UIControlState.normal)
        } else {
            cell.checkBoxOutlet.setTitle("", for: UIControlState.normal)
        }

        cell.taskCellDelegate = self
        cell.indexP = indexPath.row
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addTaskController = segue.destination as! AddTaskController
        addTaskController.addTaskDelegate = self
        addTaskController.postNewTaskCompletion = {
            self.tableView.reloadData()
        }
    }

    func backToTableView() {
        navigationController?.popViewController(animated: true)
    }
    
    func taskAdded(name: String) {
        networking.taskAddedPOST(name: name) { [weak self] in
            self?.tasksTodo = (self?.networking.tasksTodoArray)!
            self?.reloadList()
            self?.navigationController?.popViewController(animated: true)
            print("task added")
        }
    }
    
    
    func changeButton(_ cell: TaskCell) {
        if let indexPa = tableView.indexPath(for: cell) {
            let tempTask = tasksTodo[indexPa.row]
            networking.taskUpdatePUT(id: tempTask.id, name: tempTask.title, completed: !tempTask.completed) { [weak self] in
                self?.reloadList()
                self?.tasksTodo = (self?.networking.tasksTodoArray)!
                self?.navigationController?.popViewController(animated: true)
                print("task updated")
                }
            }
        }
    
    func deleteTaskButton(_ cell: TaskCell) {
        if let indexPa = tableView.indexPath(for: cell) {
            let tempTask = tasksTodo[indexPa.row]
            networking.taskDELETE(id: tempTask.id) { [weak self] in
                self?.reloadList()
                self?.tasksTodo = (self?.networking.tasksTodoArray)!
                self?.navigationController?.popViewController(animated: true)
                print("task deleted")
            }
        }
    }
    
}
