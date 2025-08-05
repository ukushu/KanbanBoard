
import SwiftUI

struct BackLogItemView: View {
    let card: KBCard
    
    init(_ card: KBCard) {
        self.card = card
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(card.id)
                .font(.custom("SF Pro", size: 8))
                .opacity(0.5)
                .monospaced()
                .fontWeight(.thin)
                .lineLimit(1)
                .frame(maxWidth: 150)
            
            Text(card.issueName)
                .font(.custom("SF Pro", size: 13))
                .fontWeight(.bold)
        }
        .padding(4)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.black.opacity(0.1))
        }
    }
}
