
import SwiftUI
import MoreSwiftUI
import Essentials

class SheetVM: ObservableObject {
    static var shared: SheetVM = SheetVM()
    @Published var sheet: SheetDialogType = .none
    
    init () { }
    
    func open<Content: View>(@ViewBuilder content: () -> Content) {
        sheet = .view(view: AnyView( content() ) )
    }
    
    func close() {
        sheet = .none
    }
}
