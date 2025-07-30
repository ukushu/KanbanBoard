
import SwiftUI
import Essentials

struct KBoardView: View {
    let projID: ProjID
    @ObservedObject var model : KBoardVM
    @ObservedObject var flow: Flow.Document<[String : [KBCardID]]>
    
    @State var titleEditId: UUID? = nil
    
    @State private var draggedTitle: UUID? = nil
    
    init(projID: ProjID) {
        self.projID = projID
        
        let firstBoard = projID.boardsDocument.content.values.first!
        
        self.model = firstBoard.viewModel
        self.flow = firstBoard.flowCards
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
        
        ForEach(Array(model.board.columns.enumerated()), id: \.element) { idx, title in
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
            .onDrag {
                self.draggedTitle = title.id
                return NSItemProvider(object: NSString(string: title.id.uuidString))
            }
            .onDrop(of: [.text], delegate: ColDropDelegate(
                current: title.id,
                draggedId: $draggedTitle,
                model: model
            ))
        }
    }
    
    @ViewBuilder
    func BoardRowTitlesAndContentView() -> some View {
        let rows = model.cells.chunked(by: model.columns.count - 1)
        
        ForEach(Array(model.board.rows.enumerated()), id: \.element) { idx, title in
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
            .onDrag {
                self.draggedTitle = title.id
                return NSItemProvider(object: NSString(string: title.id.uuidString))
            }
            .onDrop(of: [.text], delegate: RowDropDelegate(
                current: title.id,
                draggedId: $draggedTitle,
                model: model
            ))
            
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

struct ColDropDelegate: DropDelegate {
    let current: UUID
    @Binding var draggedId: UUID?
    let model: KBoardVM
    
    func performDrop(info: DropInfo) -> Bool {
        guard let draggedId = draggedId,
              let from = model.board.columns.firstIndex(where: { $0.id == draggedId }),
              let to = model.board.columns.firstIndex(where: { $0.id == current }),
              from != to
        else { return false }
        
        withAnimation {
            model.moveCol(from: from, to: to)
            self.draggedId = nil
        }
        
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedId = draggedId,
              let from = model.board.columns.firstIndex(where: { $0.id == draggedId }),
              let to = model.board.columns.firstIndex(where: { $0.id == current }),
              from != to
        else { return }
        
        withAnimation {
            model.moveCol(from: from, to: to)
            self.draggedId = draggedId
        }
    }
}


struct RowDropDelegate: DropDelegate {
    let current: UUID
    @Binding var draggedId: UUID?
    let model: KBoardVM
    
    func performDrop(info: DropInfo) -> Bool {
        guard let draggedId = draggedId,
              let from = model.board.rows.firstIndex(where: { $0.id == draggedId }),
              let to = model.board.rows.firstIndex(where: { $0.id == current }),
              from != to
        else { return false }
        
        withAnimation {
            model.moveRow(from: from, to: to)
            self.draggedId = nil
        }
        
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedId = draggedId,
              let from = model.board.rows.firstIndex(where: { $0.id == draggedId }),
              let to = model.board.rows.firstIndex(where: { $0.id == current }),
              from != to
        else { return }
        
        withAnimation {
            model.moveRow(from: from, to: to)
            self.draggedId = draggedId
        }
    }
}
