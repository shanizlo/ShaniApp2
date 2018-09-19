//
//  Networking.swift
//  ShaniApp2
//
//  Created by Shani Zlotnik on 16/09/2018.
//

import Foundation

class Networking {
    
    let urlGet = "http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080/all"
    let urlPost = "http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080/new"
    let urlPut = "http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080/update/"
    let urlDelete = "http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080/delete/{item_id}"
    
    var tasksTodoArray: [TaskTodo] = []
    var tempID = 1
    var indexT = 0
    
    let session = URLSession.shared
    
    func getJsonFromUrl(completion: @escaping () -> Void) {
        
        guard let url = URL(string: urlGet) else { return }
        
        session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let jsonData = data else { return }
            
            do {
                self?.tasksTodoArray = try JSONDecoder().decode([TaskTodo].self, from: jsonData)
                print(self?.tasksTodoArray ?? "")
            } catch {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                completion()
            }
        }.resume()
    }
    
    func taskAddedPOST(name:String, completion: @escaping () -> Void) {
        let parametersJson: [String : Any] = ["id":tempID, "title":name, "completed":false]
        let jsonDataToPost = try? JSONSerialization.data(withJSONObject: parametersJson)
        
        guard let url = URL(string: urlPost) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonDataToPost
        
        session.dataTask(with: request) { [weak self] (data, response, error) in
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
                    completion()
                }
            }
        }.resume()
    }
    
    func taskUpdatePUT(id: Int, name: String, completed: Bool, completion: @escaping () -> Void) {
        
        let parametersJson: [String : Any] = ["id":id, "title": name, "completed":completed]
        let jsonDataToPut = try? JSONSerialization.data(withJSONObject: parametersJson)
        
        guard let url = URL(string: "\(urlPut) \(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = jsonDataToPut
        
        session.dataTask(with: request) { [weak self] (data, response, error) in
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
                    completion()
                }
            }
            }.resume()
    }
    
    struct TaskTodo: Codable {
        var id = 0
        var title = ""
        var completed = false
    }
    
}
