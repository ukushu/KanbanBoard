
import SwiftUI
import Essentials

struct MainView: View {
    let projID: ProjID
    @ObservedObject var model : Flow.Document<KBoard>
    
    init(projID: ProjID) {
        self.projID = projID
        self.model = projID.boardsDocument.content.values.first!.document
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
            KBoardView(projID: projID)
            
            KBCardDraggableView(card: card, fieldFrame: fieldFrame)
        }
    }
}
