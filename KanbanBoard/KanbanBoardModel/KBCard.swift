
import Foundation
import Essentials
import SwiftUI

struct KBCard: Codable {
    var users: [KBUser]
    
    var color: Color
    var issueName: String
    var issueURL: URL?
    
    var dateCreation: Date
    var dateEnd: Date
    
    var tags: String
}

extension KBCard {
    var overdue: Bool {
        dateCreation.distance(to: dateEnd, type: .day) < 0
    }
    
    var daysLeft: String {
        let daysDistance = dateCreation.distance(to: dateEnd, type: .day)
        
        if daysDistance == 0 {
            return "TODAY"
        } else if daysDistance > 0 {
            return "\(daysDistance) days left"
        } else {
            return "\(-daysDistance) ago"
        }
    }
}
