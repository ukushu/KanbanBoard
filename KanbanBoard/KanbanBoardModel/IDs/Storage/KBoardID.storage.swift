
import Foundation
import Essentials
import SwiftUI
//import OrderedCollections

extension KBoardID {
    var storage : Flow.Storage<KBoardID> { projID.storage(boardID: self) }
    
//    var document : Flow.Document<MeshNEW> {
//        storage.lazyInit { mapID, pool in
//            Flow.Document(jsonURL: mapID.url, defaultContent: mapID.defaultContent, errors: pool)
//        }
//    }
    
//    var viewModel : KBoardID.ViewModel {
//        storage.lazyInit { mapID, _ in
//            MapID.ViewModel(mapID: mapID)
//        }
//    }
}
