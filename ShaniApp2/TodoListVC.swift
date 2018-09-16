//
//  ViewController.swift
//  ShaniApp2
//
//  Created by Shani Zlotnik on 27/08/2018.
//

import UIKit

class TodoListVC: UITableViewController, AddTaskDelegate,  ChangeButton {
    
    var tasksTodo: [TaskTodo] = []
    var tempID = 1
    
    let urlGet = "http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080/all"
    let urlPost = "http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080/new"
    let urlPut = "http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080/update/{item_id}"
    let urlDelete = "http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080/delete/{item_id}"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getJsonFromUrl(completion: { [weak self] in
            self?.tableView.reloadData()
            print("test: reloaded view")
        })
        
        print(tasksTodo)
    }
    
    func reloadList() {
        viewDidLoad()
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
        
        cell.delegate = self
        cell.indexP = indexPath.row
        cell.tasksArr = tasksTodo
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addTaskController = segue.destination as! AddTaskController
        addTaskController.addTaskDelegate = self
        addTaskController.postNewTaskCompletion = {
            self.tableView.reloadData()
        }
    }
    
    func getJsonFromUrl(completion: @escaping () -> Void) {
        
        guard let url = URL(string: urlGet) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let jsonData = data else { return }
            
            do {
                self?.tasksTodo = try JSONDecoder().decode([TaskTodo].self, from: jsonData)
                print(self?.tasksTodo ?? "")
            } catch {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                completion()
            }
        }.resume()
    }
    
    

    func taskAdded(name:String) {
        let parametersJson: [String : Any] = ["id":tempID, "title":name, "completed":false]
        let jsonDataToPost = try? JSONSerialization.data(withJSONObject: parametersJson)
        
        guard let url = URL(string: urlPost) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonDataToPost
        
        let sessionTask = URLSession.shared
        sessionTask.dataTask(with: request) { [weak self] (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                print(data)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            DispatchQueue.main.async {
                self?.viewDidLoad()
                //self?.tableView.reloadData()
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }.resume()
}
    
    func changeButton(checked: Bool, index: Int?) {
        tasksTodo[index!].completed = checked
        tableView.reloadData()
        viewDidLoad()
    }
}

struct TaskTodo: Codable {
    var id = 0
    var title = ""
    var completed = false
}

