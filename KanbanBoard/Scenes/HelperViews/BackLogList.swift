
import SwiftUI
import Essentials

struct BackLogList: View {
    let boardID: KBoardID
    @ObservedObject var documentCardDetails: Flow.Document< OrderDict<String,KBCard> >
    
    init(_ boardID: KBoardID) {
        self.boardID = boardID
        self.documentCardDetails = boardID.documentCardDetails
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button("+") {
                    SheetVM.shared.open(content: { SheetNewCard(boardID: boardID) } )
                }
                
                Text("Backlog")
            }
            
            if documentCardDetails.content.count == 0 {
                Text("Empty backlog")
                    .opacity(0.5)
            } else {
                LazyVStack {
                    ForEach(documentCardDetails.content.values) { value in
                        BackLogItemView(value)
                    }
                }
            }
        }
        .padding(6)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.1))
        }
    }
}

