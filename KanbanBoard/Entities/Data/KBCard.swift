
import Foundation
import Essentials
import MoreSwiftUI
import SwiftUI

struct KBCard: Codable, Identifiable {
    var id: String
    var users: [KBUser]
    
    var color: Color = Color(hex: 0xfef8ab)
    var issueName: String
    var issueURL: URL?
    
    var descr: String = ""
    
    var dateCreation: Date
    var dateEnd: Date?
    
    var tags: String
}

extension KBCard {
    var overdue: Bool {
        guard let dateEnd else { return false }
        
        return dateCreation.distance(to: dateEnd, type: .day) < 0
    }
    
    var daysLeft: String {
        guard let dateEnd else { return "" }
        
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
