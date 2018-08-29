//
//  ViewController.swift
//  ShaniApp2
//
//  Created by Shani Zlotnik on 27/08/2018.
//

import UIKit

class ViewController: UITableViewController, AddTask, ChangeButton {
    
    var tasksTodo: [TaskTodo] = []
    
    let urlGet = "http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080/all"
    let urlPost = "http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080/new"
    let urlPut = "http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080/update/{item_id}"
    let urlDelete = "http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080/delete/{item_id}"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasksTodo.append(TaskTodo(id: 303, title: "Soda", completed: false))
        getJsonFromUrl()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksTodo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell" , for: indexPath) as! TaskCell
        
        cell.taskNameLabel.text = tasksTodo[indexPath.row].title

        if tasksTodo[indexPath.row].completed {
            cell.checkBoxOutlet.setTitle("✓", for: UIControlState.normal)
        } else {
            cell.checkBoxOutlet.setTitle("", for: UIControlState.normal)
        }
        
        cell.delegate = self
        cell.indexP = indexPath.row
        cell.tasksArr = tasksTodo
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddTaskController
        vc.delegate = self
    }
    
    func getJsonFromUrl() {
        
        guard let url = URL(string: urlGet) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let jsonData = data else { return }
            
            do {
                self.tasksTodo = try JSONDecoder().decode([TaskTodo].self, from: jsonData)
                print(self.tasksTodo)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    //ToDo: genereate new id for new tasks
    var newId = 1
    
    func addTask(name:String) {
        tasksTodo.append(TaskTodo(id: newId, title: name, completed: false))
    }
    
    func changeButton(checked: Bool, index: Int?) {
        tasksTodo[index!].completed = checked
        tableView.reloadData()
    }
}

struct TaskTodo: Codable {
    var id = 0
    var title = ""
    var completed = false
}
