import SwiftUI

struct TableSection: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var title: String
}

@available(macOS 10.15, *)
public struct EditableTitle: View {
    var titleElem: OrderDict<UUID,String>.Element
    @State private var newValue: String = ""
    
    @Binding var editingId: UUID?
    
    let onEditEnd: (String) -> Void
    
    init(_ title: OrderDict<UUID,String>.Element, editingId: Binding<UUID?>,onEditEnd: @escaping (String) -> Void) {
        self.titleElem = title
        newValue = title.value
        _editingId = editingId
        self.onEditEnd = onEditEnd
    }
    
    @ViewBuilder
    public var body: some View {
        ZStack {
            Text(titleElem.value.isEmpty ? "[Empty]" : titleElem.value)
                .if(titleElem.value.isEmpty) { $0.opacity(0.3) }
                .opacity(editingId == titleElem.key ? 0 : 1)
            
            TextField(titleElem.value, text: $newValue,
                          onEditingChanged: { _ in },
                          onCommit: { editingId = nil; onEditEnd(newValue) } )
                .opacity(editingId == titleElem.key ? 1 : 0)
        }
        .onTapGesture(count: 2, perform: { editingId = titleElem.key } )
        .onExitCommand(perform: { editingId = nil })
        .onChange(of: editingId) {
            if newValue != titleElem.value {
                newValue = titleElem.value
            }
        }
    }
}
