
import SwiftUI
import MoreSwiftUI
import Essentials

struct SheetNewCard: View {
    @State var cardId: String = UUID().uuidString
    @State var boardID: KBoardID
    @State var card: KBCard = KBCard.sample()
    
    var body: some View {
        VStack {
            HStack {
                Text("Id: ")
                TextField("", text: $cardId)
            }
            
            HStack {
                Text("Title: ")
                TextField("", text: $card.issueName)
            }
            
            VStack(alignment: .leading) {
                Text("Descr: ")
                TextEditor(text: $card.descr)
                    .frame(minHeight: 100)
            }
            
            HStack {
                Button(action: { SheetVM.shared.close() }) {
                    Text("Cancel")
                }
                
                Button(action: addToDBAndClose) {
                    Text("OK")
                }
            }
        }
        .padding(20)
    }
}

extension SheetNewCard {
    func addToDBAndClose() {
        boardID.documentCardDetails.content[cardId] = card.fixId(boardID: self.boardID, cardID: self.cardId)
        
        SheetVM.shared.close()
    }
}


fileprivate extension KBCard {
    static func sample() -> KBCard {
        KBCard(cardID: .init(boardID: .init(projID: .sampleProject), cardId: "temp"),
               users: [],
               issueName: "",
               dateCreation: .now,
               tags: "")
    }
    
    func fixId(boardID: KBoardID, cardID: String) -> KBCard {
        KBCard(cardID: .init(boardID: boardID, cardId: cardID),
               users: self.users,
               issueName: self.issueName,
               issueURL: self.issueURL,
               dateCreation: self.dateCreation,
               dateEnd: self.dateEnd,
               tags: self.tags
        )
    }
}
