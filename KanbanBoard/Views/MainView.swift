
import SwiftUI
import Essentials

struct MainView: View {
    @State var projID: ProjID
    
    let kBoardID: KBoardID
    
    init(projID: ProjID) {
        self.projID = projID
        
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
