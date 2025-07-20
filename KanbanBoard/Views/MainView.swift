
import SwiftUI
import Essentials

struct MainView: View {
    let projID: ProjID
    @ObservedObject var model : Flow.Document<KBoard>
    
    init(projID: ProjID) {
        self.projID = projID
        self.model = projID.boardsDocument.content.values.first!.document
    }
    
    var body: some View {
        KBoardView(projID: projID)
    }
}
