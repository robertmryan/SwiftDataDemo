//
//  Subissue.swift
//  SwiftDataDemo
//
//  Created by Robert Ryan on 9/30/24.
//

import SwiftData

@Model
class Subissue {
    var name: String
    var numberEdited: Int = 0
    var issue: Issue?
    
    init(name: String, issue: Issue) {
        self.name = name
        self.numberEdited = 0
        self.issue = issue
    }
}
