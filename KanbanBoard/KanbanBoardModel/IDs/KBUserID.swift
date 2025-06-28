
import Foundation
import Essentials

struct KBUserID : Hashable, Codable {
    private(set) var id : UUID
    
    init(uuid: UUID = UUID()) {
        self.id = uuid
    }
}
