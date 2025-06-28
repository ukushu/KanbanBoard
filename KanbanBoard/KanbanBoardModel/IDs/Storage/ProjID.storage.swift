
import Foundation
import Essentials
import SwiftUI
import OrderedCollections

typealias ProjID = Flow.ProjectID
typealias OrderDict = OrderedDictionary

extension Flow.ProjectID {
    var mapListDocument : Flow.Document<OrderDict<UUID,String>> {
        storage.lazyInit { projID, pool in
            Flow.Document(jsonURL: projID.kboardUsersListUrl, defaultContent: [UUID():"my map"], errors: pool)
        }
    }
    
    func storage(boardID: KBoardID) -> Flow.Storage<KBoardID> {
        storage.lazyInit(name: boardID.id.uuidString) { _, pool in
            Flow.Storage<KBoardID>(id: boardID, pool: pool)
        }
    }
}

extension Flow.ProjectID {
    static var sampleProject : Flow.ProjectID { Flow.ProjectID(url: URL.userHome.appendingPathComponent("SampleKanbanBoardProj")) }
           var kboardUsersListUrl   : URL    { self.url.appendingPathComponent("KanbanBoardUsersList.txt") }
}
