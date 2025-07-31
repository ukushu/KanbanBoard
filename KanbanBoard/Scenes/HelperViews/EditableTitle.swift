import SwiftUI

struct TableSection: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var title: String
}

@available(macOS 10.15, *)
public struct EditableTitle: View {
    @ObservedObject var godModeVm = GodModeVM.shared
    
    var titleElem: OrderDict<UUID,String>.Element
    @State private var newValue: String = ""
    
    let onEditEnd: (String) -> Void
    
    let isVert: Bool
    
    init(isVert: Bool,_ title: OrderDict<UUID,String>.Element, onEditEnd: @escaping (String) -> Void) {
        self.isVert = isVert
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
                Button(isVert ? "↑": "←") { }
                    .buttonStyle(.link)
                
                TextField(titleElem.value, text: $newValue,
                          onEditingChanged: { _ in },
                          onCommit: { onEditEnd(newValue) } )
                
                Button(isVert ? "↓": "→") { }
                    .buttonStyle(.link)
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
}
