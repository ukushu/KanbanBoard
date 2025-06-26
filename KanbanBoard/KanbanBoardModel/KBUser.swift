
struct KBUser: Codable, Identifiable {
    var id: String { self.email }
    
    //let avatar: Getting from GRavatar
    var email: String
    var name: String
    var responsibility: String
}
