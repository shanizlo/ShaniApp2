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
        
        static var baseURL = "http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080"
        
        var httpMethod : String {
            switch self {
            case .all:
                return "GET"
            case .new:
                return "POST"
            case .update:
                return "PUT"
            case .delete:
                return "DELETE"
            }
        }
        
        var urlString : String {
                return "\(URLMethods.baseURL)/\(rawValue)"
        }
        
        func getUrlFor(id: Int) -> URL? {
            return URL(string: "\(urlString)/\(id)")
        }
        
        func getUrl() -> URL? {
            return URL(string: urlString)
        }
    }
    
    let caching = Caching()
    let taskModeling = TaskModeling()
    
    let savedTasksKey = "Saved Tasks"

    var tempID = 1
    var indexT = 0
    
    let session = URLSession.shared
    
    func loadDataFromCacheToArray() -> [TaskModeling.TaskTodo] {
        guard let resultsFromCache = caching.pullFromCache() else { return [TaskModeling.TaskTodo]() }
        return taskModeling.dataToArrayOfTasksSorted(jsonData: resultsFromCache)
    }
    
    
    func getTasksGET(completion: @escaping (_ tasks: [TaskModeling.TaskTodo]) -> Void) {

        guard let url = URLMethods.all.getUrl() else { return }
        
        session.dataTask(with: url) { [weak self] (data, response, error) in
            
            guard let jsonData = data, error == nil else {
                
                print(error?.localizedDescription as Any)
                return
            }
            
            guard let arr = self?.taskModeling.dataToArrayOfTasksSorted(jsonData: jsonData) else { return }
            let tasks = arr

            self?.caching.saveToCache(data: jsonData)

            DispatchQueue.main.async {
                completion(tasks)
            }
        }.resume()
    }
    
    
    func taskAddedPOST(name:String, completion: @escaping () -> Void) {
        
        let jsonDataToPost = getJsonParameters(id: tempID, name: name)

        let url = URLMethods.new.getUrl()
        
        var request = URLRequest(url: url!)
        request.httpMethod = URLMethods.new.httpMethod
        request.httpBody = jsonDataToPost
        
        perform(request: request, completion: completion)
    }

    func taskUpdatePUT(task: TaskModeling.TaskTodo, completion: @escaping () -> Void) {
       
        let jsonDataToPut = getJsonParameters(id: task.id, name: task.title, completed: task.completed)
        
        let url = URLMethods.update.getUrlFor(id: task.id)
        
        var request = URLRequest(url: url!)
        request.httpMethod = URLMethods.update.httpMethod
        request.httpBody = jsonDataToPut
        
        perform(request: request, completion: completion)
    }
    
    
    func taskDELETE(id: Int, completion: @escaping () -> Void) {
        
        let url = URLMethods.delete.getUrlFor(id: id)
        
        var request = URLRequest(url: url!)
        request.httpMethod = URLMethods.delete.httpMethod
        
        perform(request: request, completion: completion)
    }
    
    //Delete, Put, for Post request need to call func with tempTask, also need to think about id suffix
    func makeURLRequest(requestType: URLMethods, task: TaskModeling.TaskTodo, completion: @escaping () -> Void){
        
        let jsonDataForRequest = getJsonParameters(id: task.id, name: task.title, completed: task.completed)
        let url = requestType.getUrlFor(id: task.id)
        var request = URLRequest(url: url!)
        
        request.httpMethod = requestType.httpMethod
        request.httpBody = jsonDataForRequest
        
        perform(request: request, completion: completion)
        
    }
    
    
    func getJsonParameters(id: Int, name: String, completed: Bool = false) ->  Data? {
        let parametersJson: [String: Any] = ["id": id, "title": name, "completed": completed]
        return try? JSONSerialization.data(withJSONObject: parametersJson)
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
