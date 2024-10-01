//
//  SwiftDataDemoApp.swift
//  SwiftDataDemo
//
//  Created by Robert Ryan on 9/30/24.
//

import SwiftUI
import SwiftData

private struct TaskActorEnvironmentKey: EnvironmentKey {
    static let defaultValue: IssueModelActor? = nil
}

extension EnvironmentValues {
    var issueModelActor: IssueModelActor? {
        get { self[TaskActorEnvironmentKey.self] }
        set { self[TaskActorEnvironmentKey.self] = newValue }
    }
}

@main
struct SwiftDataDemoApp: App {
    var issueModelActor: IssueModelActor = {
        let schema = Schema([
            Issue.self,
            Subissue.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        print(modelConfiguration.url)
        let container = try! ModelContainer(for: schema, configurations: [modelConfiguration])
        return IssueModelActor(modelContainer: container)
    }()

    @State var refreshViewID: UUID = UUID()
    
    var body: some Scene {
        WindowGroup {
            ContentView(refreshViewID: $refreshViewID)
                .id(refreshViewID)
        }
        .modelContainer(issueModelActor.modelContainer)
        .environment(\.issueModelActor, issueModelActor)
    }
}
