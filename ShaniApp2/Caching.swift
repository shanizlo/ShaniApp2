//
//  Caching.swift
//  ShaniApp2
//
//  Created by Shani Zlotnik on 26/09/2018.
//

import Foundation

class Caching {
    
    let defaults = UserDefaults.standard
    
    func saveToCache(data: Any, key: String) {
        defaults.set(data, forKey: key)
        print("saved to cache")
    }
    
    
    func pullFromCache() -> Data? {
        return self.defaults.object(forKey: "Saved Tasks") as? Data
        print("pulled from cache")
    }
    
}
