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
        reloadUpdateList()
        print("view loaded from cache")
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
    }
    
    
    @objc func pullToRefresh() {
        reloadUpdateList()
        refreshControl?.endRefreshing()
    }
    
    
    func reloadUpdateList() {
        networking.getTasksGET { [weak self] tasks in
            self?.tasksTodoLocal = tasks
            self?.tableView.reloadData()
            print("view reloaded from get")
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksTodoLocal.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell" , for: indexPath) as? TaskCell else { return UITableViewCell() }
       
        let title = (indexPath.item < tasksTodoLocal.count ) ? tasksTodoLocal[indexPath.item].title : ""
        let checkboxTitle = tasksTodoLocal[indexPath.row].completed ? "✓" : ""
        cell.setup(title: title, checkBoxTitle: checkboxTitle, delegate: cell, indexPath: indexPath.row)
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let addTaskController = segue.destination as? AddTaskController else { return }
        addTaskController.addTaskDelegate = self
        addTaskController.postNewTaskCompletion = { [weak self] in
            self?.tableView.reloadData()
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
            
            guard let networking = self?.networking,
                let arr = networking.loadDataFromCacheToArray() as? [TaskModeling.TaskTodo] else { return }
            self?.tasksTodoLocal = arr
            
            self?.reloadUpdateList()
            print("task added")
        }
    }
    
    
    func changeCompletedButtonTap(_ cell: TaskCell) {
        
        if let indexPathForCell = tableView.indexPath(for: cell) {
            
            let tempTask = (indexPathForCell.row < tasksTodoLocal.count) ? tasksTodoLocal[indexPathForCell.row] : TaskModeling.TaskTodo()
            
            tasksTodoLocal[indexPathForCell.row].completed = !tempTask.completed
            tasksTodoLocal.sort { $0.completed && !$1.completed }
            tableView.reloadData()
            print("task updated locally")
            
            networking.taskUpdatePUT(task: tempTask) { [weak self] in
//                self?.reloadUpdateList()
                print("task updated")
                }
            }
        }
    
    
    func deleteTaskButtonTap(_ cell: TaskCell) {
        
        if let indexPathForCell = tableView.indexPath(for: cell) {
            
            let idToDelete = (indexPathForCell.row < tasksTodoLocal.count) ? tasksTodoLocal[indexPathForCell.row].id : 0
            
            tasksTodoLocal.remove(at: indexPathForCell.row)
            self.tableView.reloadData()
            print("task removed locally")
            
            networking.taskDELETE(id: idToDelete) { [weak self] in
                self?.reloadUpdateList()
                print("task deleted")
            }
        }
    }
    
}
