
import Foundation
import Essentials
import SwiftUI
import OrderedCollections

typealias ProjID = Flow.ProjectID

extension Flow.ProjectID {
    var boardsDocument : Flow.Document<OrderDict<UUID,KBoardID>> {
        storage.lazyInit { projID, pool in
            Flow.Document(jsonURL: projID.kboardUsersListUrl, defaultContent: [UUID(): KBoardID(projID: projID) ], errors: pool)
        }
    }
    
    func storage(boardID: KBoardID) -> Flow.Storage<KBoardID> {
        storage.lazyInit(name: boardID.id.uuidString) { _, pool in
            Flow.Storage<KBoardID>(id: boardID, pool: pool)
        }
    }
}

extension Flow.ProjectID {
    static var sampleProject : Flow.ProjectID {
        let a = URL.userHome.appendingPathComponent("SampleKanbanBoardProj")
        _ = a.makeSureDirExist()
        return Flow.ProjectID(url: a)
    }
    
    var kboardUsersListUrl   : URL    { self.url.appendingPathComponent("KanbanBoardUsersList.txt") }
}
