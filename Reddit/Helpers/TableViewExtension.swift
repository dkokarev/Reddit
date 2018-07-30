//
//  TableViewExtension.swift
//  Reddit
//
//  Created by Danil Kokarev on 31.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
 
    func insertRows(from: Int, to: Int, section: Int, with animation: UITableViewRowAnimation) {
        var indexPaths = [IndexPath]()
        
        for index in from...to {
            indexPaths.append(IndexPath(row: index, section: 0))
        }
        
        insertRows(at: indexPaths, with: animation)
    }
    
}
