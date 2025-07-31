
import SwiftUI
import MoreSwiftUI
import Essentials

struct KBoardView: View {
    let projID: ProjID
    let kBoardID: KBoardID
    @ObservedObject var flow  : Flow.Document<[String : [KBCardID]]>
    
    @State var titleEditId: UUID? = nil
    
    @State private var draggedTitle: UUID? = nil
    
    init(projID: ProjID) {
        self.projID = projID
        
        self.kBoardID = projID.boardsDocument.content.values.first!
        self.flow = kBoardID.flowCards
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button("+ row") {
                    kBoardID.insert(row: "Row \(kBoardID.flowBoard.content.rows.count + 1)")
                }
                
                Button("+ col") {
                    kBoardID.insert(col: "Col \(kBoardID.flowBoard.content.columns.count + 1)")
                }
                
                Spacer()
            }
            
            ScrollView([.horizontal, .vertical], showsIndicators: true) {
                ZStack {
                    VStack {
                        Space(20)
                        
                        ForEach(Array(kBoardID.flowBoard.content.rows.enumerated()), id: \.element) { idx, title in
                            RowView(kBoardID: kBoardID, title: title, titleEditId: $titleEditId)
                        }
                        
                        Color.clickableAlpha
                            .frame(width: 20, height: 15)
                            .onDrop(of: [.text], delegate: ColDropDelegate(
                                kBoardID: kBoardID,
                                current: nil,
                                draggedId: $titleEditId
                            ))
                    }
                    
                    HStack {
                        Space(120)
                        
                        ForEach(Array(kBoardID.flowBoard.content.columns.enumerated()), id: \.element) { idx, title in
                            ColView(kBoardID: kBoardID, title: title, titleEditId: $titleEditId)
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func BoardColTitlesView() -> some View {
        Color.clickableAlpha
            .frame(width: 100)
        
        ForEach(Array(kBoardID.flowBoard.content.columns.enumerated()), id: \.element) { idx, title in
            EditableTitle(title, editingId: $titleEditId) { newTitle in
                if let idx = kBoardID.flowBoard.content.columns.firstIndexInt(where: { $0.id == title.id }) {
                    kBoardID.rename(colIdx: idx, to: newTitle)
                }
            }
            .frame(width: 100)
            .contextMenu {
                Button("edit") {
                    titleEditId = title.id
                }
                
                Button("delete") {
                    kBoardID.remove(colId: title.id)
                }
            }
            .id(title)
            .onDrag {
                self.draggedTitle = title.id
                return NSItemProvider(object: NSString(string: title.id.uuidString))
            }
            .onDrop(of: [.text], delegate: ColDropDelegate(
                kBoardID: kBoardID,
                current: title.id,
                draggedId: $draggedTitle
            ))
        }
    }
}

#Preview {
    KBoardView(projID: .sampleProject)
}

struct ColDropDelegate: DropDelegate {
    let kBoardID: KBoardID
    let current: UUID? // nil = дроп в кінець
    @Binding var draggedId: UUID?
//    let model: KBoardVM
    
    func dropEntered(info: DropInfo) {
        doWork(info: info)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        self.draggedId = nil
        return true
    }
    
    func doWork(info: DropInfo) {
        guard let draggedId,
              let from = kBoardID.flowBoard.content.columns.firstIndex(where: { $0.id == draggedId }),
              let to = current == nil ? kBoardID.flowBoard.content.columns.count : kBoardID.flowBoard.content.columns.firstIndex(where: { $0.id == current })
        else { return }
        
        withAnimation {
            kBoardID.moveCol(from: from, to: to)
        }
    }
}


struct RowDropDelegate: DropDelegate {
    let kBoardID: KBoardID
    
    let current: UUID
    @Binding var draggedId: UUID?
//    let model: KBoardVM
    
    func performDrop(info: DropInfo) -> Bool {
        doWork(info: info)
        
        self.draggedId = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        doWork(info: info)
    }
    
    func doWork(info: DropInfo) {
        guard let draggedId = draggedId,
              let from = kBoardID.flowBoard.content.rows.firstIndex(where: { $0.id == draggedId }),
              let to   = kBoardID.flowBoard.content.rows.firstIndex(where: { $0.id == current })
        else { return }
        
        withAnimation {
            kBoardID.moveRow(from: from, to: to)
        }
    }
}


struct RowView: View {
    let kBoardID: KBoardID
    var title: TableSection
    
    @Binding var titleEditId: UUID?
    
    var body: some View {
        HStack {
            BoardTitle(kBoardID: kBoardID, title: title, titleEditId: $titleEditId)
            
            Spacer()
        }
        .background {
            Color.blue.opacity(0.2)
        }
    }
}

struct ColView: View {
    let kBoardID : KBoardID
    
    var title: TableSection
    
    @Binding var titleEditId: UUID?
    
    var body: some View {
        VStack {
            BoardTitle(kBoardID: kBoardID, title: title, titleEditId: $titleEditId)
                .onDrag {
                    self.titleEditId = title.id
                    return NSItemProvider(object: NSString(string: title.id.uuidString))
                }
                .onDrop(of: [.text], delegate: ColDropDelegate(
                    kBoardID: kBoardID,
                    current: title.id,
                    draggedId: $titleEditId
                ))
            
            Spacer()
        }
        .background {
            Color.yellow.opacity(0.2)
        }
    }
}

struct BoardTitle: View {
    let kBoardID : KBoardID
    
    var title: TableSection
    
    @Binding var titleEditId: UUID?
    
    var body: some View {
        HStack {
            Spacer()
            
            EditableTitle(title, editingId: $titleEditId) { newTitle in
                
                if let idx = kBoardID.flowBoard.content.columns.firstIndexInt(where: { $0.id == title.id }) {
                    kBoardID.rename(colIdx: idx, to: newTitle)
                }
            }
            
            Spacer()
        }
        .background(Color.clickableAlpha)
        .frame(width: 100)
        .contextMenu {
            Button("edit") {
                titleEditId = title.id
            }
            
            Button("delete") {
                kBoardID.remove(colId: title.id)
            }
        }
        .id(title)
    }
}
