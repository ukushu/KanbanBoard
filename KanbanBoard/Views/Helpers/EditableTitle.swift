import SwiftUI

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
        .onExitCommand(perform: { editingId = nil })
        .onChange(of: editingId) {
            if newValue != title.title {
                newValue = title.title
            }
        }
    }
}
