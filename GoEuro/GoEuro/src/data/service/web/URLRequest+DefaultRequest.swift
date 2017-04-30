//
//  URLRequest+DefaultRequest.swift
//  GoEuro
//
//  Created by vlad on 4/30/17.
//  Copyright © 2017 com.hat. All rights reserved.
//

import Foundation

fileprivate let baseUrl: URL = {
    let rootUrlString = "https://api.myjson.com/bins/"
    
    return URL(string: rootUrlString)!
}()

extension URLRequest {
    static func defaultGETRequest(forPath pathComponent: String) -> URLRequest {
        let url = baseUrl.appendingPathComponent(pathComponent)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
}
