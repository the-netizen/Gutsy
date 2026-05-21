import Foundation

struct Ingredient: Identifiable{
    let id: UUID
    var name: String
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}
