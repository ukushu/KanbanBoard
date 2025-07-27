
import SwiftUI
import Essentials

struct KBoardView: View {
    let projID: ProjID
    @ObservedObject var model : KBoardVM
    
    @State var titleEditId: UUID? = nil
    
    init(projID: ProjID) {
        self.projID = projID
        model = projID.boardsDocument.content.values.first!.viewModel
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button("+ row") {
                    model.insert(row: "Row \(model.board.rows.count + 1)")
                }
                
                Button("+ col") {
                    model.insert(col: "Col \(model.board.columns.count + 1)")
                }
                
                Button("Refresh") {
                    model.objectWillChange.send()
                }
                
                Spacer()
            }
            
            ScrollView([.horizontal, .vertical], showsIndicators: true) {
                LazyVGrid(columns: model.columns, spacing: 7) {
                    BoardColTitlesView()
                    
                    BoardRowTitlesAndContentView()
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func BoardColTitlesView() -> some View {
        Color.clickableAlpha
            .frame(width: 100)
        
        ForEach(Array(model.board.columns.enumerated()), id: \.offset) { idx, title in
            EditableTitle(title, editingId: $titleEditId) { newTitle in
                if let idx = model.board.columns.firstIndexInt(where: { $0.id == title.id }) {
                    model.rename(colIdx: idx, to: newTitle)
                }
            }
            .frame(width: 100)
            .contextMenu {
                Button("edit") {
                    titleEditId = title.id
                }
                
                Button("delete") {
                    model.remove(colId: title.id)
                }
            }
            .id(title)
        }
    }
    
    @ViewBuilder
    func BoardRowTitlesAndContentView() -> some View {
        let rows = model.cells.chunked(by: model.columns.count - 1)
        
        ForEach(Array(model.board.rows.enumerated()), id: \.offset) { idx, title in
            EditableTitle(title, editingId: $titleEditId) { newTitle in
                if let idx = model.board.rows.firstIndexInt(where: { $0.id == title.id }) {
                    model.rename(rowIdx: idx, to: newTitle)
                }
            }
            .contextMenu {
                Button("edit") {
                    titleEditId = title.id
                }
                
                Button("delete") {
                    model.remove(rowId: title.id)
                }
            }
            .id(title)
            
            if rows.count > 0 {
                ForEach(rows[idx] ) { cell in
                    cell.asView()
                }
            }
        }
    }
}

#Preview {
    KBoardView(projID: .sampleProject)
}
