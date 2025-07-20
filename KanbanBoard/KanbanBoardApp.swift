
import SwiftUI

@main
struct KanbanBoardApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(projID: .sampleProject)
        }
    }
}
