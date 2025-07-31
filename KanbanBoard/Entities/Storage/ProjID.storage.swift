
import Foundation
import Essentials
import SwiftUI
import OrderedCollections

typealias ProjID = Flow.ProjectID

extension Flow.ProjectID {
    var boardsListDocument : Flow.Document<[UUID]> {
        storage.lazyInit { projID, pool in
            Flow.Document(jsonURL: projID.boardsListUrl, defaultContent: [], errors: pool)
        }
    }
    
    func storage(boardID: KBoardID) -> Flow.Storage<KBoardID> {
        storage.lazyInit(name: boardID.id.uuidString) { _, pool in
            Flow.Storage<KBoardID>(id: boardID, pool: pool)
        }
    }
}

extension Flow.ProjectID {
    var boardsListUrl : URL   { self.url.appendingPathComponent("KanbanBoardList.txt") }
    var usersListUrl  : URL   { self.url.appendingPathComponent("KanbanBoardUsersList.txt") }
}
