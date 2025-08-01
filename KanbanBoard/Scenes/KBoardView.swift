
import SwiftUI
import MoreSwiftUI
import Essentials

class GodModeVM: ObservableObject {
    static let shared: GodModeVM = GodModeVM()
    @Published var inEdit: Bool = false
}

struct KBoardView: View {
    let kBoardID: KBoardID
    @ObservedObject var document : Flow.Document<KBoard>
    @ObservedObject var documentCards : Flow.Document<[String : [KBCardID]]>
    @ObservedObject var godModeVm = GodModeVM.shared
    
    init(kBoardID: KBoardID) {
        self.kBoardID = kBoardID
        self.document = kBoardID.document
        self.documentCards = kBoardID.documentCards
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("God mode") {
                    godModeVm.inEdit.toggle()
                }
            }
            
            ScrollView([.horizontal, .vertical], showsIndicators: true) {
                ZStack {
                    VStack {
                        Space(20)
                        
                        ForEach(Array(kBoardID.document.content.rows.enumerated()), id: \.element.key ) { item in
                            RowView(kBoardID: kBoardID, titleElem: item.element)
                        }
                        
                        AddRowBtn()
                    }
                    
                    HStack {
                        Space(120)
                        
                        ForEach(Array(kBoardID.document.content.columns.enumerated()), id: \.element.key ) { item in
                            ColView(kBoardID: kBoardID, titleElem: item.element)
                        }
                        
                        AddColBtn()
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
    let titleElem: OrderDict<UUID,String>.Element
    
    var body: some View {
        HStack {
            BoardTitle(isCol: false, kBoardID: kBoardID, titleElem: titleElem)
            
            Spacer()
        }
        .background {
            Color.blue.opacity(0.2)
        }
    }
}

fileprivate struct ColView: View {
    let kBoardID : KBoardID
    
    let titleElem: OrderDict<UUID,String>.Element
    
    var body: some View {
        VStack {
            BoardTitle(isCol: true, kBoardID: kBoardID, titleElem: titleElem)
            
            Spacer()
        }
        .background {
            Color.yellow.opacity(0.2)
        }
    }
}

fileprivate struct BoardTitle: View {
    @ObservedObject var godModeVm = GodModeVM.shared
    
    let isCol: Bool
    let kBoardID : KBoardID
    let titleElem: OrderDict<UUID,String>.Element
    
    var body: some View {
        HStack {
            EditableTitle(kBoardID: kBoardID, isCol: isCol, title: titleElem) { newTitle in
                kBoardID.document.content.columns[titleElem.key] = newTitle
            }
        }
        .background(Color.clickableAlpha)
        .frame(width: 100)
        .if(godModeVm.inEdit) {
            $0.contextMenu {
                Button("delete") {
                    kBoardID.remove(colId: titleElem.key)
                }
            }
        }
        .id(titleElem.value)
    }
}
