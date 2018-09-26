//
//  Caching.swift
//  ShaniApp2
//
//  Created by Shani Zlotnik on 26/09/2018.
//

import Foundation

class Caching {
    
    let defaults = UserDefaults.standard
        
    func saveToCache(data: Any?) {
        defaults.set(data, forKey: "Saved Tasks") //saving to cache
        print("saved to cache:")
        print(data)
    }
    
    
    func pullFromCache() -> Data? {
        let savedData = self.defaults.object(forKey: "Saved Tasks") as? Data
        print("data pulled from cached:")
        print(savedData)
        return savedData
//        {
////            if let loadedData = try? JSONDecoder().decode([TaskTodo].self, from: savedData) {
//            if let loadedData = try? JSONDecoder().decode(ofType, from: savedData) {
//                print("loadedData")
//                print(loadedData)
//            }
//        }
        
        
    }
    
}
