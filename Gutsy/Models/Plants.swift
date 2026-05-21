import Foundation

struct Plants: Codable {
    let name: String
    let group: String
    let benefit: String
    
    var id: String { name } //identified via unique name
}

