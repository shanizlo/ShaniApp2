//
//  Caching.swift
//  ShaniApp2
//
//  Created by Shani Zlotnik on 26/09/2018.
//

import Foundation

class Caching {
    
    let defaults = UserDefaults.standard
        
    func saveToCache(data: Any) {
        defaults.set(data, forKey: "Saved Tasks")
        print("saved to cache")
    }
    
    
    func pullFromCache() -> Data? {
        let savedData = self.defaults.object(forKey: "Saved Tasks") as? Data
        print("data pulled from cache")
        return savedData
    }
    
}
