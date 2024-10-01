//
//  Issue.swift
//  SwiftDataDemo
//
//  Created by Robert Ryan on 9/30/24.
//

import Foundation
import SwiftData

@Model
class Issue {
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \Subissue.issue)
    var subissues: [Subissue]

    init(name: String, subIssues: [Subissue] = []) {
        self.name = name
        self.subissues = subIssues
    }
}
