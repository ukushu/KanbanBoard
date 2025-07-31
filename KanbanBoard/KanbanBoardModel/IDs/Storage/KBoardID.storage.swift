
import Foundation
import Essentials
import SwiftUI
import OrderedCollections

extension KBoardID {
    var storage : Flow.Storage<KBoardID> { projID.storage(boardID: self) }
    
    var updatesBoard: Flow.Signal<KBoard> { self.flowBoard.$content }
    var updatesCards: Flow.Signal<[String: [KBCardID]]> { self.flowCards.$content }
    
    var flowBoard : Flow.Document<KBoard> {
        return storage.lazyInit { boardID, pool in
            Flow.Document(jsonURL: boardID.kBoardUrl, defaultContent: KBoard(), errors: pool)
        }
    }
    
    var flowCards : Flow.Document<[String: [KBCardID]]> {
        return storage.lazyInit { boardID, pool in
            Flow.Document(jsonURL: boardID.kBoardCardsUrl, defaultContent: [:], errors: pool)
        }
    }
    
//    var viewModel : KBoardVM {
//        storage.lazyInit { boardID, _ in
//            KBoardVM(boardID: boardID)
//        }
//    }
}


//struct KBoardID {
//    static var flow: Flow.Document<ConfigFile> { Flow.ProjectID.memProjID.config }
//    static var bind: Binding<ConfigFile> { Flow.ProjectID.memProjID.configBinding }
//    static var val: ConfigFile { Config.bind.wrappedValue }
//    static var updates: Flow.Signal<ConfigFile> { Flow.ProjectID.memProjID.config.$content }
//}
