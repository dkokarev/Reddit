//
//  Pageable.swift
//  Reddit
//
//  Created by Danil Kokarev on 29.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation

protocol Pageable {
    
    var loading: Bool { get }
    var marker: String? { get }
    
    func loadNextPage(after: String?)
    
}
