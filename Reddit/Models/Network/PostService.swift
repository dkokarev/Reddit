//
//  PostService.swift
//  Reddit
//
//  Created by Danil Kokarev on 29.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation

struct PostService {
    
    typealias PostCompletion = (Page?, Error?) -> ()
    
    static func topPosts(limit: UInt = 10, after: String?, completion: @escaping PostCompletion) -> URLSessionDataTask? {
        let target = PostTarget.top(limit: limit, after: after)
        
        guard let request = Router().request(for: target) else {
            completion(nil, nil)
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil || data == nil {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
 
            do {
                let page = try JSONDecoder().decode(Page.self, from: data!)
                DispatchQueue.main.async { completion(page, nil) }
            } catch let error {
                DispatchQueue.main.async { completion(nil, error) }
            }
        }
        
        task.resume()
        return task
    }
    
}

enum PostTarget: TargetType {
    
    case top (limit: UInt, after: String?)
    
    var path: String {
        return "top.json"
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        switch self {
        case .top(let limit, let after):
            var parameters = ["limit" : String(limit)]
            
            if after != nil {
                parameters["after"] = after!
            }
            
            return parameters
        }
    }
    
}
