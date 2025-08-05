
import SwiftUI

struct BackLogItemView: View {
    let card: KBCard
    
    init(cardID: KBCardID) {
        self.card = KBCard(cardID: cardID, users: [], issueName: "", dateCreation: .now, tags: "")  //cardID card
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(card.cardID.id)
                .font(.custom("SF Pro", size: 10))
                .opacity(0.5)
                .monospaced()
                .fontWeight(.thin)
            
            Text(card.issueName)
                .font(.custom("SF Pro", size: 10))
                .fontWeight(.bold)
        }
    }
}
