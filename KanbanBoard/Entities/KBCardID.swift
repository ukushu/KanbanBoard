
import Foundation
import Essentials

struct KBCardID : Hashable, Codable, Identifiable {
    public var boardID: UUID
    private(set) var id: String
    
    init(boardID: KBoardID, cardId: String) {
        self.boardID = boardID.id
        self.id = cardId
    }
}
