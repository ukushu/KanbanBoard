
import SwiftUI
import MoreSwiftUI
import Essentials

struct KBoardView: View {
    let kBoardID: KBoardID
    @ObservedObject var docCards : Flow.Document<[String : [KBCardID]]>
    
    @State var titleEditId: UUID? = nil
    
    @State private var draggedTitle: UUID? = nil
    
    init(kBoardID: KBoardID) {
        self.kBoardID = kBoardID
        self.docCards = kBoardID.documentCards
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button("+ row") {
                    kBoardID.insert(row: "Row \(kBoardID.document.content.rows.count + 1)")
                }
                
                Button("+ col") {
                    kBoardID.insert(col: "Col \(kBoardID.document.content.columns.count + 1)")
                }
                
                Spacer()
            }
            
            ScrollView([.horizontal, .vertical], showsIndicators: true) {
                ZStack {
                    VStack {
                        Space(20)
                        
                        ForEach(Array(kBoardID.document.content.rows.enumerated()), id: \.element.key ) { item in
                            RowView(kBoardID: kBoardID, titleElem: item.element, titleEditId: $titleEditId)
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
                        
                        ForEach(Array(kBoardID.document.content.columns.enumerated()), id: \.element.key ) { item in
                            ColView(kBoardID: kBoardID, titleElem: item.element, titleEditId: $titleEditId)
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
        
        ForEach(Array(kBoardID.document.content.columns.enumerated()), id: \.element.key ) { item in
            EditableTitle(item.element, editingId: $titleEditId) { newTitle in
                kBoardID.document.content.columns[item.element.key] = newTitle
            }
            .frame(width: 100)
            .contextMenu {
                Button("edit") {
                    titleEditId = item.element.key
                }
                
                Button("delete") {
                    kBoardID.remove(colId: item.element.key)
                }
            }
            .id(item.element.value)
            .onDrag {
                self.draggedTitle = item.element.key
                return NSItemProvider(object: NSString(string: item.element.key.uuidString))
            }
            .onDrop(of: [.text], delegate: ColDropDelegate(
                kBoardID: kBoardID,
                current: item.element.key,
                draggedId: $draggedTitle
            ))
        }
    }
}

struct ColDropDelegate: DropDelegate {
    let kBoardID: KBoardID
    let current: UUID? // nil = дроп в кінець
    @Binding var draggedId: UUID?
    
    func dropEntered(info: DropInfo) {
        doWork(info: info)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        self.draggedId = nil
        return true
    }
    
    func doWork(info: DropInfo) {
        guard let draggedId,
              let from = kBoardID.document.content.columns.index(forKey: draggedId)
        else { return }
        
        let to: Int
        if let current {
            to = kBoardID.document.content.columns.index(forKey: current) ?? kBoardID.document.content.columns.count
        } else {
            to = kBoardID.document.content.columns.count
        }
        
        withAnimation {
            kBoardID.moveCol(from: from, to: to)
        }
    }
}

//struct RowDropDelegate: DropDelegate {
//    let kBoardID: KBoardID
//    
//    let current: UUID
//    @Binding var draggedId: UUID?
//    
//    func performDrop(info: DropInfo) -> Bool {
//        doWork(info: info)
//        
//        self.draggedId = nil
//        return true
//    }
//    
//    func dropEntered(info: DropInfo) {
//        doWork(info: info)
//    }
//    
//    func doWork(info: DropInfo) {
//        guard let draggedId = draggedId,
//              let from = kBoardID.flowBoard.content.rows.keys.firstIndex(of: draggedId),
//        else { return }
//        
//        let to: Int
//        if let current {
//            to = kBoardID.flowBoard.content.rows.values.index(forKey: current) ?? kBoardID.flowBoard.content.columns.count
//        } else {
//            to = kBoardID.flowBoard.content.rows.count
//        }
//        
//        
//        withAnimation {
//            kBoardID.moveRow(from: from, to: to)
//        }
//    }
//}

struct RowView: View {
    let kBoardID: KBoardID
    let titleElem: OrderDict<UUID,String>.Element
    
    @Binding var titleEditId: UUID?
    
    var body: some View {
        HStack {
            BoardTitle(kBoardID: kBoardID, titleElem: titleElem, titleEditId: $titleEditId)
            
            Spacer()
        }
        .background {
            Color.blue.opacity(0.2)
        }
    }
}

struct ColView: View {
    let kBoardID : KBoardID
    
    let titleElem: OrderDict<UUID,String>.Element
    
    @Binding var titleEditId: UUID?
    
    var body: some View {
        VStack {
            BoardTitle(kBoardID: kBoardID, titleElem: titleElem, titleEditId: $titleEditId)
                .onDrag {
                    self.titleEditId = titleElem.key
                    return NSItemProvider(object: NSString(string: titleElem.key.uuidString))
                }
                .onDrop(of: [.text], delegate: ColDropDelegate(
                    kBoardID: kBoardID,
                    current: titleElem.key,
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
    
    let titleElem: OrderDict<UUID,String>.Element
    
    @Binding var titleEditId: UUID?
    
    var body: some View {
        HStack {
            Spacer()
            
            EditableTitle(titleElem, editingId: $titleEditId) { newTitle in
                kBoardID.document.content.columns[titleElem.key] = newTitle
            }
            
            Spacer()
        }
        .background(Color.clickableAlpha)
        .frame(width: 100)
        .contextMenu {
            Button("edit") {
                titleEditId = titleElem.key
            }
            
            Button("delete") {
                kBoardID.remove(colId: titleElem.key)
            }
        }
        .id(titleElem.value)
    }
}
