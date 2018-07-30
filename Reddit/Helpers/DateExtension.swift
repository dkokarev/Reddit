//
//  DateExtension.swift
//  Reddit
//
//  Created by Danil Kokarev on 30.07.2018.
//  Copyright © 2018 Danil Kokarev. All rights reserved.
//

import Foundation

extension Date {
    
    private struct Item {
        let multi: String
        let last: String
        let value: Int?
    }
    
    private var components: DateComponents {
        return Calendar.current.dateComponents(
               [.second, .minute, .hour, .day, .weekOfYear, .month, .year],
               from: self,
               to: Date())
    }
    
    private var items: [Item] {
        let dateComponents = components
        return [
            Item(multi: "years ago", last: "Last year", value: dateComponents.year),
            Item(multi: "months ago", last: "Last month", value: dateComponents.month),
            Item(multi: "weeks ago", last: "Last week", value: dateComponents.weekday),
            Item(multi: "days ago", last: "Yesterday", value: dateComponents.day),
            Item(multi: "hours ago", last: "An hour ago", value: dateComponents.hour),
            Item(multi: "minutes ago", last: "A minute ago", value: dateComponents.minute),
            Item(multi: "seconds ago", last: "Just now", value: dateComponents.second)
        ]
    }
    
    // MARK: - Public Methods
    
    public func timeAgoSinceNow() -> String {
        for item in items {
            switch item.value {
            case let .some(step) where step == 0:
                continue
            case let .some(step) where step == 1:
                return item.last
            case let .some(step):
                return String(step) + " " + item.multi
            default:
                continue
            }
        }
        return "Just now"
    }
    
}
