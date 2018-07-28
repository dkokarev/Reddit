//
//  ParametersEncoder.swift
//  Reddit
//
//  Created by Danil Kokarev on 28.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation

typealias Parameters = [String: Any]

protocol ParameterEncoding {
    static func encode(_ request: inout URLRequest, with parameters: Parameters)
}

struct URLEncoding: ParameterEncoding {
    
    static func encode(_ request: inout URLRequest, with parameters: Parameters) {
        guard let url = request.url else { return }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                let queryValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                let queryItem = URLQueryItem(name: key, value: queryValue)
                urlComponents.queryItems?.append(queryItem)
            }
            
            request.url = urlComponents.url
        }
        
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
    
}
