
import SwiftUI

@main
struct KanbanBoardApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(kBoardID: ProjID.sampleProject.boardsDocument.content.values.first! )
        }
    }
}
