
import SwiftUI
import Essentials

struct ProjView: View {
    let projID: ProjID
    @ObservedObject var boardsListDocument : Flow.Document<[UUID]>
    
    let kBoardID: KBoardID
    
    init(projID: ProjID) {
        self.projID = projID
        self.boardsListDocument = projID.boardsListDocument
        
        if let uuidBoardId = projID.boardsListDocument.content.first {
            self.kBoardID = KBoardID(projID: projID, uuid: uuidBoardId)
        } else {
            let kBoardID = KBoardID(projID: projID)
            projID.boardsListDocument.content = [kBoardID.id]
            self.kBoardID = kBoardID
        }
    }
    
    var body: some View {
        ZStack {
            KBoardView(kBoardID: kBoardID)
        }
    }
}
