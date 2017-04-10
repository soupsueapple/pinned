//
//  AFAppDotNetAPIClient.swift
//  pinned
//
//  Created by 汤坤 on 2017/3/31.
//  Copyright © 2017年 Kun Soup. All rights reserved.
//

import UIKit
import AFNetworking

class AFAppDotNetAPIClient: AFHTTPSessionManager {
    
    private static let baseURL: String = "https://api.pinboard.in/v1/"
    
    private static let instance: AFAppDotNetAPIClient = AFAppDotNetAPIClient(baseURL: URL(string: baseURL))
    
    
    class func shareAFAppDotNetAPIClient() -> AFAppDotNetAPIClient {
        instance.securityPolicy = AFSecurityPolicy.init(pinningMode: .none)
        instance.responseSerializer = AFHTTPResponseSerializer()
        instance.responseSerializer.acceptableContentTypes = ["text/html", "text/plain", "text/xml","application/json", "text/json", "text/javascript"]
        
        return instance
    }
    
    func httpError(error: Error?) -> Bool{
        if error != nil{
            
            return true
        }
        
        return false
    }
   
    func getRequest(url: String!, paramters: Dictionary<String, String>!, block: @escaping (_ responseObject: Any?, _ error: Error?) -> Void){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        var p: Dictionary<String, String>! = paramters;
        
        if p != nil {
            p["format"] = "json"
        }else{
            p = ["format": "json"]
        }
        
        self.get(url, parameters: p, progress: nil, success: {(task: URLSessionDataTask?, json: Any?) -> Void in
            
            block(json, nil)
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        }, failure: {(task: URLSessionDataTask?, error: Error?) -> Void in
            
            block(nil, error)
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        })
    }
    
    func postRequest(url: String!, paramters: Dictionary<String, String>!, block: @escaping (_ responseObject: Any?, _ error: Error?) -> Void){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        self.post(url, parameters: paramters, progress: nil, success: {(task: URLSessionDataTask?, json: Any?) -> Void in
            
            block(json, nil)
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        }, failure: {(task: URLSessionDataTask?, error: Error?) -> Void in
            
            block(nil, error)
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }
    
    func loginRequest(username: String!, password: String!){
        
        
        self.requestSerializer.setAuthorizationHeaderFieldWithUsername(username, password: password)
    }
}
