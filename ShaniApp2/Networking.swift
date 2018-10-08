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
        
        func getUrlFor(id: Int) -> URL? { //Not sure if this is right to do - I want this to return URL not string
            // TODO: * You can just return it like this, as the `URL(string:` initializer returns URL? as well:
            // return URL(string: "\(urlString)/\(id)") * - it doesn't work
            if let url = URL(string: "\(urlString)/\(id)") {
                return url
            } else { return nil }
        }
        
        func getUrl() -> URL? {
            // TODO: * Same as above: `return URL(string: urlString)`
            if let url = URL(string: urlString) {
                return url
            } else { return nil }
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

        let url = URLMethods.all.getUrl()
        
         // TODO: * Avoid using `!` * don't know how to unwrap the parameter
        session.dataTask(with: url!) { [weak self] (data, response, error) in
            
            guard let jsonData = data, error == nil else {
                
                print(error?.localizedDescription)
                return
            }
            
            // TODO: * Avoid using `!` * tried to unwrap this way - but it doesn't work:
//            guard let tasks = self?.taskModeling.dataToArrayOfTasksSorted(jsonData: jsonData) as? [TaskModeling.TaskTodo()] else { return }

            let tasks = (self?.taskModeling.dataToArrayOfTasksSorted(jsonData: jsonData))!

            // TODO: Don't know how to avoid ! here
            self?.caching.saveToCache(data: jsonData,key: (self?.savedTasksKey)!)

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

    // * TODO: `taskUpdatePUT`, and `taskAddedPOST` are almost the same. Think how can you join them (maybe even together with DELETE). * Need time for it - will resolve later after resolving the url unwrapping
    
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
    
    
    func getJsonParameters(id: Int, name: String, completed: Bool = false) ->  Data? {
        let parametersJson: [String: Any] = ["id": id, "title": name, "completed": completed]
        return try? JSONSerialization.data(withJSONObject: parametersJson)
    }
    
    
    func perform(request: URLRequest, completion: @escaping () -> Void) {
        session.dataTask(with: request) {(data, response, error) in
            // * TODO: Aren't you doing something with the returned data?
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
