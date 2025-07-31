
import SwiftUI
import Essentials

struct ProjView: View {
    let projID: ProjID
    @ObservedObject var boardsListDocument : Flow.Document<[UUID]>
    
    init(projID: ProjID) {
        self.projID = projID
        self.boardsListDocument = projID.boardsListDocument
    }
    
    var body: some View {
        KBoardView(kBoardID: projID.defaultBoardID)
    }
}

fileprivate extension ProjID {
    var defaultBoardID : KBoardID {
        if let uuidBoardId = self.boardsListDocument.content.first {
            return KBoardID(projID: self, uuid: uuidBoardId)
        } else {
            let kBoardID = KBoardID(projID: self)
            self.boardsListDocument.content = [kBoardID.id]
            return kBoardID
        }
    }
}
