//
//  CacheData.swift
//  pinned
//
//  Created by 汤坤 on 2017/3/31.
//  Copyright © 2017年 Kun Soup. All rights reserved.
//

import Foundation

class CacheData{
    
    static func saveCache(key: String, value: Any){
        let setting = UserDefaults()
        setting.set(value, forKey: key)
        setting.synchronize()
    }
    
    static func cache(key: String) -> Any{
        let setting = UserDefaults()
        let any = setting.object(forKey: key)
        return any as Any
    }
    
    
    static func saveCacheExtension(key: String, value: Any){
        let setting = UserDefaults(suiteName: "group.SoupMain")
        setting?.set(value, forKey: key)
        setting?.synchronize()
    }
    
    static func cacheExtension(key: String) -> Any{
        let setting = UserDefaults(suiteName: "group.SoupMain")
        let any = setting?.object(forKey: key)
        return any as Any
    }
}
