
import SwiftUI
import MoreSwiftUI
import Essentials

struct SheetNewCard: View {
    @State var cardId: String = UUID().uuidString
    @State var boardID: KBoardID
    @State var card: KBCard = KBCard.sample()
    @State var warn: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Id: ")
                TextField("", text: $cardId)
                    .onChange(of: cardId) { _, _ in updWarn() }
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
                .disabled(needToBlockOkBtn)
            }
            
            Text(warn)
                .foregroundStyle(.red.opacity(0.5))
        }
        .padding(20)
    }
}

extension SheetNewCard {
    var needToBlockOkBtn: Bool {
        card.issueName.count <= 2 ||
        cardId.count == 0 ||
        boardID.documentCardDetails.content.keys.contains(cardId)
    }
    
    func updWarn() {
        var txt = ""
        
        if boardID.documentCardDetails.content.keys.contains(cardId) {
            txt += "ID already exist"
        }
        
        if cardId.count == 0 {
            txt += "ID cannot be empty"
        }
        
        self.warn = txt
    }
    
    func addToDBAndClose() {
        boardID.documentCardDetails.content[cardId] = card.fixId(cardID: self.cardId)
        
        SheetVM.shared.close()
    }
}


fileprivate extension KBCard {
    static func sample() -> KBCard {
        KBCard(id: "temp",
               users: [],
               issueName: "",
               descr: "",
               dateCreation: .now,
               tags: ""
        )
    }
    
    func fixId(cardID: String) -> KBCard {
        KBCard(id: cardID,
               users: self.users,
               issueName: self.issueName,
               issueURL: self.issueURL,
               descr: self.descr,
               dateCreation: self.dateCreation,
               dateEnd: self.dateEnd,
               tags: self.tags
        )
    }
}
