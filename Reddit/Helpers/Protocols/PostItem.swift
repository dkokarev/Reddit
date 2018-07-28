//
//  PostItem.swift
//  Reddit
//
//  Created by Danil Kokarev on 28.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation

protocol PostItem {
    
    var id: String { get }
    var author: String { get }
    var numberOfComments: Int { get }
    var date: Date { get }
    
}
