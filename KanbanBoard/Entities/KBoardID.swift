import Foundation
import Essentials


// must not be codable!
struct KBoardID : Hashable, Identifiable {
    public let projID: Flow.ProjectID
    private(set) var id : UUID
    
    init(projID: Flow.ProjectID, uuid: UUID = UUID()) {
        self.projID = projID
        self.id = uuid
    }
}

extension KBoardID {
    var url: URL                { self.projID.url.appendingPathComponent("\(self.id)_kBoard.txt") }
    var cardsUrl: URL           { self.projID.url.appendingPathComponent("\(self.id)_kBoardCards.txt") }
}

extension Flow.ProjectID {
    var newRandomBoard : KBoardID { KBoardID(projID: self, uuid: UUID()) }
}
