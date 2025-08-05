
import SwiftUI
import MoreSwiftUI

struct BackLogItemView: View {
    let card: KBCard
    
    init(_ card: KBCard) {
        self.card = card
    }
    
    var body: some View {
        HStack {
            Text.sfIcon("line.3.horizontal", size: 15)
                .makeFullyIntaractable()
                .onDrag {
                    NSItemProvider(object: card.id as NSString)
                }
            
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
        }
        .padding(4)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.black.opacity(0.1))
        }
        .overlay {
            helpBtn()
        }
    }
    
    func helpBtn() -> some View {
        HStack {
            Spacer()
            
            VStack {
                PopoverButtSimple(label: {
                    Text("?")
                        .background {
                            Circle()
                                .fill(Color.black.opacity(0.5))
                                .padding(-3)
                                .blur(radius: 2)
                        }
                }) {
                    Text(card.descr)
                        .padding()
                }
                .buttonStyle(.link)
                
                Spacer()
            }
        }
        .padding(.horizontal, 4)
    }
}
