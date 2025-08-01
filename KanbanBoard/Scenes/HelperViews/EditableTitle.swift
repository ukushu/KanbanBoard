import SwiftUI

struct TableSection: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var title: String
}

@available(macOS 10.15, *)
public struct EditableTitle: View {
    let kBoardID: KBoardID
    @ObservedObject var godModeVm = GodModeVM.shared
    
    var titleElem: OrderDict<UUID,String>.Element
    @State private var newValue: String = ""
    
    let onEditEnd: (String) -> Void
    
    let isCol: Bool
    
    init(kBoardID: KBoardID, isCol: Bool, title: OrderDict<UUID,String>.Element, onEditEnd: @escaping (String) -> Void) {
        self.kBoardID = kBoardID
        self.isCol = isCol
        self.titleElem = title
        newValue = title.value
        self.onEditEnd = onEditEnd
    }
    
    @ViewBuilder
    public var body: some View {
        ZStack {
            Text(titleElem.value.isEmpty ? "[Empty]" : titleElem.value)
                .if(titleElem.value.isEmpty) { $0.opacity(0.3) }
                .opacity(godModeVm.inEdit ? 0 : 1)
            
            HStack(spacing: 0) {
                TextField(titleElem.value, text: $newValue,
                          onEditingChanged: { _ in },
                          onCommit: { onEditEnd(newValue) } )
                
                SortBtns()
            }
            .opacity(godModeVm.inEdit ? 1 : 0)
        }
        .onChange(of: godModeVm.inEdit) {
            onEditEnd(newValue)
        }
        .onExitCommand {
            newValue = titleElem.value
        }
    }
    
    @ViewBuilder
    func SortBtns() -> some View {
        Group {
            Button(action: {
                if isCol {
                    let idx = kBoardID.document.content.columns.index(forKey: titleElem.key)
                    guard let idx, idx > 0 else { return }
                    kBoardID.document.content.columns.swapAt(idx, idx-1)
                } else {
                    let idx = kBoardID.document.content.rows.index(forKey: titleElem.key)
                    guard let idx, idx > 0 else { return }
                    kBoardID.document.content.rows.swapAt(idx, idx-1)
                }
            }) {
                Text(isCol ? "◀︎" : "▲")
            }
            
            Button(action: {
                if isCol {
                    let idx = kBoardID.document.content.columns.index(forKey: titleElem.key)
                    guard let idx, idx < kBoardID.document.content.columns.count - 1 else { return }
                    kBoardID.document.content.columns.swapAt(idx, idx+1)
                } else {
                    let idx = kBoardID.document.content.rows.index(forKey: titleElem.key)
                    guard let idx, idx < kBoardID.document.content.rows.count - 1 else { return }
                    kBoardID.document.content.rows.swapAt(idx, idx+1)
                }
            }) {
                Text(isCol ? "▶︎" : "▼")
            }
        }
        .buttonStyle(.link)
        .font(.custom("SF Pro", size: 10))
        .modify { view in
            if isCol {
                HStack( spacing: 2) {
                    view
                }
            } else {
                VStack( spacing: 0) {
                    view
                }
            }
        }
        .cursor(.pointingHand)
    }
}
