import Foundation

struct KBTitle: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var title: String
}
