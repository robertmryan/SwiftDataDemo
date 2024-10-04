//
//  ContentView.swift
//  SwiftDataDemo
//
//  Created by Robert Ryan on 9/30/24.
//

import SwiftUI
import SwiftData

// MARK: Content view showing the information and calling the above methods
struct ContentView: View {
    @Binding var refreshViewID: UUID

    @Environment(\.modelContext) var modelContext
    @Environment(\.issueModelActor) var issueModelActor

    @Query var allIssues: [Issue]
    @State var selectedIssue: Issue?

    @State var didTapInsert = false
    @State var didTapDeleteAll = false

    var body: some View {
        VStack {
            Section("Data") {
                HStack {
                    Spacer()

                    VStack {
                        Text("Issue Count: \(allIssues.count)")
                        Text("SubIssue Count: \(subissueCount())")
                    }

                    Spacer()

                    Button {
                        refreshViewID = UUID()
                    } label: {
                        Text("Refresh View")
                    }

                    Spacer()
                }
            }

            Section("Actions") {
                HStack {
                    Spacer()

                    Button {
                        didTapInsert.toggle()
                    } label: {
                        Text("Insert")
                    }
                    .disabled(didTapInsert || didTapDeleteAll)

                    Spacer()

                    Button {
                        didTapDeleteAll.toggle()
                    } label: {
                        Text("Delete All")
                    }
                    .disabled(didTapInsert || didTapDeleteAll)

                    Spacer()
                }
            }
#if os(macOS)
            Divider()
#endif
            HStack {
                List(selection: $selectedIssue) {
                    ForEach(allIssues) { issue in
                        Button {
                            selectedIssue = issue
                        } label: {
                            HStack {
                                Spacer()
                                Text(issue.name).bold()
                                Spacer()
                                Text("Subissues: \(issue.subissues.count)")
                                Spacer()
                            }
                        }
                    }
                }

                if let selectedIssue {
                    SubissuesView(issue: selectedIssue)
                } else {
                    Text("Please select an issue to see the subissues involved.")
                        .multilineTextAlignment(.center)
                }
            }
        }
        .task(id: didTapInsert) {
            guard didTapInsert else { return }

            do {
                try await issueModelActor?.insert()
            } catch {
                print(error)
            }

            didTapInsert = false
        }
        .task(id: didTapDeleteAll) {
            guard didTapDeleteAll else { return }

            do {
                try await issueModelActor?.deleteAll()

                // or, theoretically, you could iterate through them; note, you don't need to delete subissues w cascade delete relationship
                //
                // for issue in allIssues {
                //     modelContext.delete(issue)
                // }
                // try modelContext.save()
            } catch {
                print(error)
            }

            didTapDeleteAll = false
        }
    }

    func subissueCount() -> Int {
        let count = try? modelContext.fetchCount(FetchDescriptor<Subissue>())
        return count ?? 0
    }
}

#Preview {
    @Previewable @State var uuid = UUID()
    ContentView(refreshViewID: $uuid)
        .modelContainer(for: [Issue.self, Subissue.self], inMemory: true)
}
