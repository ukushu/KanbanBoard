
import Foundation
import Essentials
import SwiftUI
import OrderedCollections

extension KBoardID {
    var storage : Flow.Storage<KBoardID> { projID.storage(boardID: self) }
    
    var updatesBoard: Flow.Signal<KBoard> { self.document.$content }
    var updatesCards: Flow.Signal<[String: [KBCardID]]> { self.documentCards.$content }
    
    var document : Flow.Document<KBoard> {
        return storage.lazyInit { boardID, pool in
            Flow.Document(jsonURL: boardID.url, defaultContent: KBoard(), errors: pool)
        }
    }
    
    var documentCards : Flow.Document<[String: [KBCardID]]> {
        return storage.lazyInit { boardID, pool in
            Flow.Document(jsonURL: boardID.cardsUrl, defaultContent: [:], errors: pool)
        }
    }
    
    var documentCardDetails : Flow.Document<[UUID: [KBCard]]> {
        return storage.lazyInit { boardID, pool in
            Flow.Document(jsonURL: boardID.cardsUrl, defaultContent: [:], errors: pool)
        }
    }
}
