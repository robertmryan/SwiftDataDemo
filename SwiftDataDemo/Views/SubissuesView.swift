//
//  SubissuesView.swift
//  SwiftDataDemo
//
//  Created by Robert Ryan on 10/4/24.
//

import SwiftUI
import SwiftData

struct SubissuesView: View {
    @Query var subissues: [Subissue]

    init(issue: Issue?) {
        let issueId = issue?.persistentModelID
        let predicate = #Predicate<Subissue> { $0.issue?.persistentModelID == issueId }
        _subissues = Query(filter: predicate)
    }

    var body: some View {
        List(subissues) { subIssue in
            HStack {
                Spacer()
                Text(subIssue.name).bold()
                Spacer()
                if subIssue.numberEdited > 0 {
                    Text("Edited: \(subIssue.numberEdited)").bold()
                } else {
                    Text("Edited: \(subIssue.numberEdited)").tint(.secondary)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    SubissuesView(issue: nil)
}
