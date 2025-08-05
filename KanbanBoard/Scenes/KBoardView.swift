
import SwiftUI
import MoreSwiftUI
import Essentials

class GodModeVM: ObservableObject {
    static let shared: GodModeVM = GodModeVM()
    @Published var inEdit: Bool = false
}

struct KBoardView: View {
    let kBoardID: KBoardID
    @ObservedObject var document: Flow.Document<KBoard>
    @ObservedObject var godModeVm = GodModeVM.shared
    
    init(kBoardID: KBoardID) {
        self.kBoardID = kBoardID
        self.document = kBoardID.document
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("God mode") {
                    godModeVm.inEdit.toggle()
                }
            }
            
            ScrollView([.horizontal, .vertical], showsIndicators: true) {
                HStack(alignment: .top) {
                    BackLogList(kBoardID)
                    
                    ZStack {
                        VStack {
                            Space(20)
                            
                            ForEach(Array(kBoardID.document.content.rows.enumerated()), id: \.element.key ) { item in
                                RowView(kBoardID: kBoardID, titleElem: item.element)
                            }
                            
                            AddRowBtn()
                        }
                        .animation(.default, value: kBoardID.document.content.rows)
                        
                        HStack {
                            Space(120)
                            
                            ForEach(Array(kBoardID.document.content.columns.enumerated()), id: \.element.key ) { item in
                                ColView(kBoardID: kBoardID, titleElem: item.element)
                            }
                            
                            AddColBtn()
                        }
                        .animation(.default, value: kBoardID.document.content.columns)
                    }
                }
            }
        }
        .padding()
    }
}

fileprivate extension KBoardView {
    @ViewBuilder
    func AddColBtn() -> some View {
        if godModeVm.inEdit {
            VStack {
                Button("+") {
                    kBoardID.insert(col: "Col \(kBoardID.document.content.columns.count + 1)")
                }
                
                Space()
            }
        }
    }
    
    @ViewBuilder
    func AddRowBtn() -> some View {
        if godModeVm.inEdit {
            HStack {
                Button("+") {
                    kBoardID.insert(row: "Row \(kBoardID.document.content.rows.count + 1)")
                }
                
                Space()
            }
        }
    }
}

fileprivate struct RowView: View {
    let kBoardID: KBoardID
    @ObservedObject var document : Flow.Document<KBoard>
    
    let titleElem: OrderDict<UUID,String>.Element
    
    init(kBoardID: KBoardID, titleElem: OrderDict<UUID, String>.Element) {
        self.kBoardID = kBoardID
        self.document = kBoardID.document
        self.titleElem = titleElem
    }
    
    var body: some View {
        HStack {
            BoardTitle(kBoardID: kBoardID, titleElem: titleElem, isCol: false)
            
            Spacer()
        }
        .background {
            (kBoardID.document.content.colors[titleElem.key] ?? Color.blue).opacity(0.2)
        }
    }
}

fileprivate struct ColView: View {
    let kBoardID : KBoardID
    @ObservedObject var document : Flow.Document<KBoard>
    
    let titleElem: OrderDict<UUID,String>.Element
    
    init(kBoardID: KBoardID, titleElem: OrderDict<UUID, String>.Element) {
        self.kBoardID = kBoardID
        self.document = kBoardID.document
        
        self.titleElem = titleElem
    }
    
    var body: some View {
        VStack {
            BoardTitle(kBoardID: kBoardID, titleElem: titleElem, isCol: true)
            
            Spacer()
        }
        .background {
            (kBoardID.document.content.colors[titleElem.key] ?? Color.yellow).opacity(0.2)
        }
    }
}

fileprivate struct BoardTitle: View {
    @ObservedObject var godModeVm = GodModeVM.shared
    
    let kBoardID : KBoardID
    let titleElem: OrderDict<UUID,String>.Element
    let isCol: Bool
    
    var body: some View {
        EditableTitle(kBoardID: kBoardID, title: titleElem, isCol: isCol) { newTitle in
            if isCol {
                if let _ = kBoardID.document.content.columns[titleElem.key] {
                    kBoardID.document.content.columns[titleElem.key] = newTitle
                }
            } else {
                if let _ = kBoardID.document.content.rows[titleElem.key] {
                    kBoardID.document.content.rows[titleElem.key] = newTitle
                }
            }
        }
        .background(Color.clickableAlpha)
        .frame(width: 100)
        .if(godModeVm.inEdit) {
            $0.contextMenu {
                Button("delete") {
                    if isCol {
                        kBoardID.remove(colId: titleElem.key)
                    } else {
                        kBoardID.remove(rowId: titleElem.key)
                    }
                }
            }
        }
        .id(titleElem.value)
    }
}
