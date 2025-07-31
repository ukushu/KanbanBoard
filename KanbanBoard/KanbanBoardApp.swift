
import Essentials
import SwiftUI

@main
struct KanbanBoardApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(projID: .sampleProject )
        }
    }
}

extension Flow.ProjectID {
    static var sampleProject : Flow.ProjectID {
        let a = URL.userHome.appendingPathComponent("SampleKanbanBoardProj")
        _ = a.makeSureDirExist()
        return Flow.ProjectID(url: a)
    }
}
