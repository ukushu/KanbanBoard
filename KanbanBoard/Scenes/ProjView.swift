
import SwiftUI
import Essentials

struct ProjView: View {
    let projID: ProjID
    @ObservedObject var boardsListDocument : Flow.Document<OrderDict<UUID,KBoardID>>
    
    let kBoardID: KBoardID
    
    init(projID: ProjID) {
        self.projID = projID
        self.boardsListDocument = projID.boardsListDocument
        
        if let kBoardID = projID.boardsListDocument.content.values.first {
            self.kBoardID = kBoardID
        } else {
            let kBoardID = KBoardID(projID: projID)
            projID.boardsListDocument.content[UUID()] = kBoardID
            self.kBoardID = kBoardID
        }
        
        
    }
    
    var body: some View {
        ZStack {
            KBoardView(kBoardID: kBoardID)
        }
    }
}
