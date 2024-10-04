//
//  IssueModelActor.swift
//  SwiftDataDemo
//
//  Created by Robert Ryan on 10/1/24.
//

import Foundation
import SwiftData
import os.log

@ModelActor
actor IssueModelActor {
    let poi = OSSignposter(subsystem: "IssueModelActor", category: .pointsOfInterest)
    let count = 1000

    func insert() async throws {
        let state = poi.beginInterval(#function, id: poi.makeSignpostID())
        defer { poi.endInterval(#function, state) }

        let issueId = try insertIssue(name: "MA - Issue: \(Date.now.timeIntervalSince1970)")

        for i in 1...count {
            try insertSubissue(name: "\(i)", issueId: issueId)
        }

        try save()
    }

    func deleteAll() throws {
        let state = poi.beginInterval(#function, id: poi.makeSignpostID())
        defer { poi.endInterval(#function, state) }

        try modelContext.delete(model: Issue.self)
        try save()
    }
}

private extension IssueModelActor {
    @discardableResult
    func insertIssue(name: String) throws -> PersistentIdentifier {
        // let state = poi.beginInterval(#function, id: poi.makeSignpostID())
        // defer { poi.endInterval(#function, state) }

        let issue = Issue(name: name)
        modelContext.insert(issue)
        try modelContext.save()
        return issue.persistentModelID
    }

    @discardableResult
    func insertSubissue(name: String, issueId: PersistentIdentifier) throws -> PersistentIdentifier {
        // let state = poi.beginInterval(#function, id: poi.makeSignpostID())
        // defer { poi.endInterval(#function, state) }

        guard let issue = modelContext.model(for: issueId) as? Issue else {
            throw IssueModelActorError.issueNotFound
        }
        let subissue = Subissue(name: name, issue: issue)
        modelContext.insert(subissue)
        return subissue.persistentModelID
    }

    func save() throws {
        // let state = poi.beginInterval(#function, id: poi.makeSignpostID())
        // defer { poi.endInterval(#function, state) }

        try modelContext.save()
    }
}

extension IssueModelActor {
    enum IssueModelActorError: Error {
        case issueNotFound
    }
}
