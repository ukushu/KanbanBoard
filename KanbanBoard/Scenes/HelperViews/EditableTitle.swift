
import SwiftUI
import MoreSwiftUI

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
    
    @State var color: Color
    
    init(kBoardID: KBoardID, title: OrderDict<UUID,String>.Element, isCol: Bool, onEditEnd: @escaping (String) -> Void) {
        self.kBoardID = kBoardID
        self.isCol = isCol
        self.titleElem = title
        newValue = title.value
        self.onEditEnd = onEditEnd
        
        self.color = kBoardID.document.content.colors[title.key] ?? (isCol ? Color(hex: 0xf9d84a) : Color(hex: 0x3b82f7) )
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
        .onChange(of: color) {
            kBoardID.document.content.colors[titleElem.key] = color
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
                    
                    UksColorPicker(color: $color).frame(width: 10, height: 10)
                }
            } else {
                VStack( spacing: 0) {
                    view
                    
                    UksColorPicker(color: $color).frame(width: 10, height: 10)
                }
            }
        }
        .cursor(.pointingHand)
    }
}
