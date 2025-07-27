
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


@available(macOS 10.15, *)
public struct EditableTitle: View {
    @State var title: KBTitle
    @State private var newValue: String = ""
    
    @Binding var editingId: UUID?
    
    let onEditEnd: (String) -> Void
    
    init(_ title: KBTitle, editingId: Binding<UUID?>,onEditEnd: @escaping (String) -> Void) {
        self.title = title
        newValue = title.title
        _editingId = editingId
        self.onEditEnd = onEditEnd
    }
    
    @ViewBuilder
    public var body: some View {
        ZStack {
            // Text variation of View
            Text(title.title.isEmpty ? "[Empty]" : title.title)
                .if(title.title.isEmpty) { $0.opacity(0.3) }
                .opacity(editingId == title.id ? 0 : 1)
            
            // TextField for edit mode of View
            TextField(title.title, text: $newValue,
                          onEditingChanged: { _ in },
                          onCommit: { editingId = nil; onEditEnd(newValue) } )
                .opacity(editingId == title.id ? 1 : 0)
        }
        // Enable EditMode on double tap
        .onTapGesture(count: 2, perform: { editingId = title.id } )
        // Exit from EditMode on Esc key press
        .onExitCommand(perform: { editingId = nil; newValue = title.title })
    }
}

#Preview {
    KBoardView(projID: .sampleProject)
}
