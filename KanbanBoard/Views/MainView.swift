
import SwiftUI
import Essentials

struct MainView: View {
    let kBoardID: KBoardID
    @ObservedObject var model : Flow.Document<KBoard>
    
    @GestureState private var dragLocation = CGPoint.zero
    
    init(kBoardID: KBoardID) {
        self.kBoardID = kBoardID
        self.model = kBoardID.projID.boardsDocument.content.values.first!.document
    }
    
    @State private var fieldFrame: CGRect = .zero
    let card = KBCard(
        users: [KBUser(email: "gmail.com", name: "Куся", responsibility: "dev")],
            issueName: "Фікс бага",
            issueURL: URL(string: "https://example.com"),
            dateCreation: Date(),
            dateEnd: Date().addingTimeInterval(86400),
            tags: "bug,urgent"
        )
    
    
    var body: some View {
        ZStack {
            KBoardView(projID: kBoardID.projID)
                .coordinateSpace(name: "globalArea")
            
            KBCardDraggableView(kBoardID: kBoardID, card: card, fieldFrame: fieldFrame, dragLocation: $dragLocation)
        }
    }
}
