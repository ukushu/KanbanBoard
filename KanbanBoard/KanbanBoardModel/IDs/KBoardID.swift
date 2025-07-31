import Foundation
import Essentials

struct KBoardID : Hashable, Identifiable, Codable {
    public let projID: Flow.ProjectID
    private(set) var id : UUID
    
    init(projID: Flow.ProjectID, uuid: UUID = UUID()) {
        self.projID = projID
        self.id = uuid
    }
}

extension KBoardID {
    var kBoardUrl: URL                { self.projID.url.appendingPathComponent("\(self.id)_kBoard.txt") }
    var kBoardCardsUrl: URL           { self.projID.url.appendingPathComponent("\(self.id)_kBoardCards.txt") }
}

extension Flow.ProjectID {
    var newRandomBoard : KBoardID { KBoardID(projID: self, uuid: UUID()) }
}
