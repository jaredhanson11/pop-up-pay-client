//
//  HTTPUtils.swift
//  AVStarter
//
//  Created by Steven Chen on 6/21/17.
//  Copyright © 2017 Steven Chen. All rights reserved.
//

import Foundation

class HTTPUtils {
    class func getRequest(_ toUrl: String, success: @escaping (Data?) -> Void, failed: @escaping (Error?) -> Void, badResponse: @escaping (URLResponse) -> Void) {
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: URL(string: toUrl)!)
        request.httpMethod = "GET"
        
        session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil || response == nil {
                failed(error)
            } else if (response as! HTTPURLResponse).statusCode != 200 {
                badResponse(response!)
            } else {
                success(data)
            }
        }).resume()
    }
    
    class func postRequest(_ toUrl: String, data: [String : String], success: @escaping (Data?) -> Void, failed: @escaping (Error?) -> Void, badResponse: @escaping (URLResponse) -> Void) {
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: URL(string: toUrl)!)
        request.httpMethod = "POST"
        
        let dataString = encodeData(data)
        
        request.httpBody = dataString.data(using: .utf8)
        session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil || response == nil {
                failed(error)
            } else if (response as! HTTPURLResponse).statusCode != 200 {
                badResponse(response!)
            } else {
                success(data)
            }
        }).resume()
    }
    
    class func encodeData(_ data : [String : String]) -> String{
        var pairs = [String]()
        for (key, val) in data {
            pairs.append("\(key)=\(String(val)!)")
            print(val)
        }
        
        var dataString = pairs[0]
        for i in 1..<pairs.count {
            dataString += "&\(pairs[i])"
        }
        
        return dataString
    }
    
}

