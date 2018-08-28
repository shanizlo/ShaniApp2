//
//  ViewController.swift
//  ShaniApp2
//
//  Created by Shani Zlotnik on 27/08/2018.
//

import UIKit

class ViewController: UITableViewController, AddTask, ChangeButton {
    
    var tasks: [Task] = []
    var tasksTodo: [TaskTodo] = []
    
    let urlGet = "http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080/all"
    let urlPost = "http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080/new"
    let urlPut = "http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080/update/{item_id}"
    let urlDelete = "http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080/delete/{item_id}"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasks.append(Task(name: "milk"))
        //TODO:
        getJsonFromUrl()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell" , for: indexPath) as! TaskCell
        
        cell.taskNameLabel.text = tasks[indexPath.row].name
        
        if tasks[indexPath.row].checked {
            cell.checkBoxOutlet.setTitle("✓", for: UIControlState.normal)
        } else {
            cell.checkBoxOutlet.setTitle("", for: UIControlState.normal)
        }
        
        cell.delegate = self
        cell.indexP = indexPath.row
        cell.tasks = tasks
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddTaskController
        vc.delegate = self
    }
 /////////////
    /////////////////////////////
    
    func getJsonFromUrl() {
        
        guard let url = URL(string: urlGet) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            
            do {
                let list = try JSONDecoder().decode([TaskTodo].self, from: data)
                print(list)
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
        }.resume()
    }
    
    /////////////////////////////
    
   ////////
    
    func addTask(name: String) {
        tasks.append(Task(name: name))
        tableView.reloadData()
    }
    
    func changeButton(checked: Bool, index: Int?) {
        tasks[index!].checked = checked
        tableView.reloadData()
    }
}

class Task {
    var name = ""
    var checked = false
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}

struct TaskTodo: Decodable {
    var id = 0
    var title = ""
    var completed = false
}




