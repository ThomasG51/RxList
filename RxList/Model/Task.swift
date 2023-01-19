//
//  Task.swift
//  RxList
//
//  Created by Thomas George on 18/01/2023.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
