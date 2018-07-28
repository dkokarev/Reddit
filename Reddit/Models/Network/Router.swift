//
//  Router.swift
//  Reddit
//
//  Created by Danil Kokarev on 28.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation

struct Router {
    
    var baseUrl: URL = Config.baseURL
    
    func request(for target: TargetType) -> URLRequest? {
        let url = baseUrl.appendingPathComponent(target.path)
        
        var request = URLRequest(url: url)
        request.httpMethod = target.httpMethod.rawValue
        
        if let parameters = target.parameters {
            URLEncoding.encode(&request, with: parameters)
        }
        
        return request
    }
    
}
