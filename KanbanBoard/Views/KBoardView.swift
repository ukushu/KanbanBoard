
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
                    model.insert(row: "hello1")
                }
                
                Button("+ col") {
                    model.insert(col: "hello")
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
            EditableTitle(title.title) { newTitle in
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
                    model.remove(colIdx: idx)
                }
            }
        }
    }
    
    @ViewBuilder
    func BoardRowTitlesAndContentView() -> some View {
        let rows = model.cells.chunked(by: model.columns.count - 1)
        
        ForEach(Array(model.board.rows.enumerated()), id: \.offset) { idx, title in
            EditableTitle(title.title) { newTitle in
                if let idx = model.board.rows.firstIndexInt(where: { $0.id == title.id }) {
                    model.rename(rowIdx: idx, to: newTitle)
                }
            }
            .contextMenu {
                Button("edit") {
                    titleEditId = title.id
                }
                
                Button("delete") {
                    model.remove(rowIdx: idx)
                }
            }
            
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
    @State var text: String
    @State private var newValue: String = ""
    
    @State var editProcessGoing = false { didSet{ newValue = text } }
    
    let onEditEnd: (String) -> Void
    
    public init(_ txt: String, onEditEnd: @escaping (String) -> Void) {
        text = txt
        self.onEditEnd = onEditEnd
    }
    
    @ViewBuilder
    public var body: some View {
        ZStack {
            // Text variation of View
            Text(text.isEmpty ? "[Empty]" : text)
                .if(text.isEmpty) { $0.opacity(0.3) }
                .opacity(editProcessGoing ? 0 : 1)
            
            // TextField for edit mode of View
            TextField("", text: $newValue,
                          onEditingChanged: { _ in },
                          onCommit: { text = newValue; editProcessGoing = false; onEditEnd(newValue) } )
                .opacity(editProcessGoing ? 1 : 0)
        }
        // Enable EditMode on double tap
        .onTapGesture(count: 2, perform: { editProcessGoing = true } )
        // Exit from EditMode on Esc key press
        .onExitCommand(perform: { editProcessGoing = false; newValue = text })
    }
}

#Preview {
    KBoardView(projID: .sampleProject)
}


