
import SwiftUI
import Essentials

struct KBoardView: View {
    let projID: ProjID
    @ObservedObject var model : KBoardVM
    
    init(projID: ProjID) {
        self.projID = projID
        model = projID.boardsDocument.content.values.first!.viewModel
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
        VStack {
            HStack {
                Spacer()
                
                Text("Cols: \(model .columns.count); Cells in col: \(model.board.cells.count / max(model.columns.count, 1) )")
                
                Button("+ row") {
                    model.insert(row: "hello1")
                }
                
                Button("+ col") {
                    model.insert(column: "hello")
                }
                
                Spacer()
            }
            
            ScrollView([.horizontal, .vertical], showsIndicators: true) {
                LazyVGrid(columns: model.columns, spacing: 7) {
                    ForEach(Array(model.board.columns.enumerated()), id: \.offset) { idx, text in
                        Text(text)
                            .frame(width: 100)
                    }
                    
                    ForEach(Array(model.board.cells.enumerated()), id: \.element) { idx, cell in
                        cell.asView()
                    }
                }
            }
            
            KBCardDraggableView(card: card, fieldFrame: fieldFrame)
        }
        .padding()
    }
}

#Preview {
    KBoardView(projID: .sampleProject)
}
