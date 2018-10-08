//
//  Caching.swift
//  ShaniApp2
//
//  Created by Shani Zlotnik on 26/09/2018.
//

import Foundation

class Caching {
    
    let defaults = UserDefaults.standard
    let keySavedTasks: String = "Saved Tasks"
    
    func saveToCache(data: Any) {
        defaults.set(data, forKey: keySavedTasks)
        print("saved to cache")
    }
    
    
    func pullFromCache() -> Data? {
        return self.defaults.object(forKey: keySavedTasks) as? Data
        print("pulled from cache")
    }
    
}
