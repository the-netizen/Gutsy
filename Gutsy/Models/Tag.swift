import SwiftUI
import SwiftData

@Model
class Tag {
    var name: String
    var colorName: String
    @Relationship(inverse: \MealLog.tags) var meals: [MealLog] = []

    init(name: String, colorName: String) {
        self.name = name
        self.colorName = colorName
    }

    // Look up the asset color by name
    var color: Color {
        Color(colorName)
    }
    
}

extension Tag {
    static let palette: [String] = [
        "color_fruits", "color_vegetables", "color_wholegrains",
        "color_legumes", "color_nuts", "color_herbs"
    ]
}
