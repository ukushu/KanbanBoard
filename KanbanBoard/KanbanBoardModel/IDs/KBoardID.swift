import Foundation
import Essentials

struct KBoardID : Hashable, Identifiable {
    public let projID: Flow.ProjectID
    private(set) var id : UUID
    
    init(projID: Flow.ProjectID, uuid: UUID = UUID()) {
        self.projID = projID
        self.id = uuid
    }
}

extension Flow.ProjectID {
    var newRandomBoard : KBoardID { KBoardID(projID: self, uuid: UUID()) }
}
