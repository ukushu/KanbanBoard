
import Foundation
import Essentials

struct KBCardID : Hashable, Codable {
    public var boardID: UUID
    private(set) var id : UUID
    
    init(boardID: KBoardID, uuid: UUID = UUID()) {
        self.boardID = boardID.id
        self.id = uuid
    }
}
