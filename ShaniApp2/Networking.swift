//
//  Networking.swift
//  ShaniApp2
//
//  Created by Shani Zlotnik on 16/09/2018.
//

import Foundation

class Networking {
    
    enum URLMethods: String {
        case all
        case new
        case update
        case delete
        
        static var baseURL = "http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080/"
        
        var urlString : String {
            return "\(URLMethods.baseURL)/\(rawValue)"
        }
        
        func getUrlFor(id: Int) -> String {
            return "\(urlString)/\(id)"
        }
        
    }
    

    let caching = Caching()
    let taskModeling = TaskModeling()
    
    var tasksTodoArray: [TaskModeling.TaskTodo] = []
    
    var tempID = 1
    var indexT = 0
    
    let session = URLSession.shared
    
    func loadDataFromCache() { //put it here because it needs struct TaskTodo from Networking class to decode
        do {
            tasksTodoArray = try JSONDecoder().decode([TaskModeling.TaskTodo].self, from: caching.pullFromCache()!)
            self.tasksTodoArray.sort { $0.completed && !$1.completed }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func getJsonFromUrl(completion: @escaping () -> Void) {
        
        guard let url = URL(string: URLMethods.all.urlString) else { return }

        session.dataTask(with: url) { [weak self] (data, response, error) in
        
            guard let jsonData = data else { return }
        
            do {
                self?.tasksTodoArray = try JSONDecoder().decode([TaskModeling.TaskTodo].self, from: jsonData)
                self?.tasksTodoArray.sort { $0.completed && !$1.completed }
                print("got data from url")
            } catch {
                print(error.localizedDescription)
            }
            self?.caching.saveToCache(data: jsonData)

            DispatchQueue.main.async {
                completion()
            }
        }.resume()
    }
  
    
    func taskAddedPOST(name:String, completion: @escaping () -> Void) {
        let jsonDataToPost = getJsonParameters(id: tempID, name: name)
        
        guard let url = URL(string: URLMethods.new.urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonDataToPost

        perform(request: request, completion: completion)
    }
    
    
    func taskUpdatePUT(id: Int, name: String, completed: Bool, completion: @escaping () -> Void) {
        let jsonDataToPut = getJsonParameters(id: id, name: name, completed: completed)
        let urlString = URLMethods.update.getUrlFor(id: id)
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = jsonDataToPut
        
        perform(request: request, completion: completion)
    }
    
    
    func getJsonParameters(id: Int, name: String, completed: Bool = false) ->  Data? {
        let parametersJson: [String: Any] = ["id": id, "title": name, "completed": completed]
        return try? JSONSerialization.data(withJSONObject: parametersJson)
    }
    
    
    func taskDELETE(id: Int, completion: @escaping () -> Void) {
        
        guard let url = URL(string: URLMethods.delete.getUrlFor(id: id)) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        perform(request: request, completion: completion)
    }
    
    
    func perform(request: URLRequest, completion: @escaping () -> Void) {
        session.dataTask(with: request) {(data, response, error) in
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

}
