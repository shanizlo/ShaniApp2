//
//  ViewController.swift
//  ShaniApp2
//
//  Created by Shani Zlotnik on 27/08/2018.
//

import UIKit

class TodoListVC: UITableViewController, AddTaskDelegate, TaskCellDelegate {
    
    let networking = Networking()
    let taskModeling = TaskModeling()
    var tasksTodoLocal: [TaskModeling.TaskTodo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasksTodoLocal = networking.loadDataFromCacheToArray()
        self.tableView.reloadData()
        print("view loaded from cache")
        networking.getJsonFromUrl(completion: { [weak self] tasks in
           self?.tasksTodoLocal = tasks
           self?.tableView.reloadData()
            print("view reloaded from get")
       })
    }
    
    func reloadUpdateList() {
        networking.getJsonFromUrl(completion: { [weak self] tasks in
            self?.tasksTodoLocal = tasks
            self?.tableView.reloadData()
            print("view reloaded from get")
        })
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksTodoLocal.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell" , for: indexPath) as! TaskCell
        
        cell.taskNameLabel.text = tasksTodoLocal[indexPath.item].title

        if tasksTodoLocal[indexPath.row].completed {
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
    
    func taskAddTap(name: String) {
        tasksTodoLocal.append(TaskModeling.TaskTodo(id: 1, title: name, completed: false)) //some temp task because id will be known only after POST
        print("added temp task to local")
        print(tasksTodoLocal)
        self.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
        networking.taskAddedPOST(name: name) { [weak self] in
            self?.tasksTodoLocal = (self?.networking.loadDataFromCacheToArray())!
            self?.reloadUpdateList()
//            self?.navigationController?.popViewController(animated: true)
            print("task added")
        }
    }
    
    
    func changeCompletedButtonTap(_ cell: TaskCell) {
        
        if let indexPathForCell = tableView.indexPath(for: cell) {
            
            let tempTask = tasksTodoLocal[indexPathForCell.row]
            
            tasksTodoLocal[indexPathForCell.row].completed = !tempTask.completed
            self.tableView.reloadData()
            print("task updated locally")
            
            networking.taskUpdatePUT(id: tempTask.id, name: tempTask.title, completed: !tempTask.completed) { [weak self] in
                self?.reloadUpdateList()
                self?.navigationController?.popViewController(animated: true)
                print("task updated")
                }
            }
        }
    
    func deleteTaskButtonTap(_ cell: TaskCell) {
        
        if let indexPathForCell = tableView.indexPath(for: cell) {
            
            let tempTask = tasksTodoLocal[indexPathForCell.row]
            
            tasksTodoLocal.remove(at: indexPathForCell.row)
            self.tableView.reloadData()
            print("task removed locally")
            
            networking.taskDELETE(id: tempTask.id) { [weak self] in
                self?.reloadUpdateList()
                self?.navigationController?.popViewController(animated: true)
                print("task deleted")
            }
        }
    }
    
}
