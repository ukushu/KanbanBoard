
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
                            .onDrop(of: [.text], delegate: DropDelegateImpl(
                                boardID: boardID,
                                item: value
                            ))
                    }
                }
                .animation(.bouncy, value: documentCardDetails.content.keys)
            }
        }
        .padding(6)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.1))
        }
    }
}

///
/// Helpers
///

fileprivate struct DropDelegateImpl: DropDelegate {
    let boardID: KBoardID
    let item: KBCard
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let fromID = info.itemProviders(for: [.text]).first?.loadObject(ofClass: NSString.self, completionHandler: { id, _ in
            DispatchQueue.main.async {
                guard let fromID = id as? String,
                      let fromIndex = boardID.documentCardDetails.content.keys.firstIndex(of: fromID),
                      let toIndex = boardID.documentCardDetails.content.keys.firstIndex(of: item.id),
                      fromID != item.id
                else { return }
                
                withAnimation{
                    boardID.documentCardDetails.content.swapAt(fromIndex, toIndex)
                }
            }
        }) else { return }
    }
}
