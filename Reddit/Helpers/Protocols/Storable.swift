//
//  Storable.swift
//  Reddit
//
//  Created by Danil Kokarev on 31.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation

protocol Storable {
    
    associatedtype Item
    
    func save(_ item: Item, withFilename filename: String)
    func getItem(withFilename filename: String) -> Item?
    func removeItem(withFilename filename: String)
    func path(forFilename filename: String) -> URL?
    
}
