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
        
        func getUrlFor(id: Int) -> URL? { //Not sure if this is right to do - I want this to return URL not string
            if let url = URL(string: "\(urlString)/\(id)") {
                return url
            } else { return nil }
        }
        
        func getUrl() -> URL? {
            if let url = URL(string: urlString) {
                return url
            } else { return nil }
        }
    }
    

    let caching = Caching()
    let taskModeling = TaskModeling()

    var tempID = 1
    var indexT = 0
    
    let session = URLSession.shared
    
    func loadDataFromCacheToArray() -> [TaskModeling.TaskTodo] {
        return taskModeling.jsonToArrayOfTasksSorted(json: caching.pullFromCache()!)
    }
    
    
    func getJsonFromUrl(completion: @escaping (_ tasks: [TaskModeling.TaskTodo]) -> Void) {

        let url = URLMethods.all.getUrl()

        session.dataTask(with: url!) { [weak self] (data, response, error) in
            
            guard let jsonData = data, error == nil else {
                
                print(error?.localizedDescription)
                return
            }

            let tasks = (self?.taskModeling.jsonToArrayOfTasksSorted(json: jsonData))!

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
        request.httpMethod = "POST"
        request.httpBody = jsonDataToPost
        
        perform(request: request, completion: completion)
    }

    
    func taskUpdatePUT(id: Int, name: String, completed: Bool, completion: @escaping () -> Void) {
       
        let jsonDataToPut = getJsonParameters(id: id, name: name, completed: completed)
        
        let url = URLMethods.update.getUrlFor(id: id)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.httpBody = jsonDataToPut
        
        perform(request: request, completion: completion)
    }
    
    
    func taskDELETE(id: Int, completion: @escaping () -> Void) {
        
        let url = URLMethods.delete.getUrlFor(id: id)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        
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
