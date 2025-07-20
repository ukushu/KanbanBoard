
import Foundation
import Essentials
import SwiftUI
import OrderedCollections

extension KBoardID {
    var storage : Flow.Storage<KBoardID> { projID.storage(boardID: self) }
    
    var document : Flow.Document<KBoard> {
        return storage.lazyInit { boardID, pool in
            Flow.Document(jsonURL: Flow.ProjectID.sampleProject.kBoardUrl, defaultContent: KBoard(), errors: pool)
        }
    }
    
    var viewModel : KBoardVM {
        storage.lazyInit { boardID, _ in
            KBoardVM(boardID: boardID)
        }
    }
}
