import SwiftUI
import SwiftData

enum TagStorage {
    static func findOrCreate(name: String, colorName: String, in context: ModelContext) -> Tag {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        let descriptor = FetchDescriptor<Tag>(predicate: #Predicate { $0.name == trimmed })
        if let existing = try? context.fetch(descriptor).first {
            existing.colorName = colorName     // update color on reuse
            return existing
        }
        let tag = Tag(name: trimmed, colorName: colorName)
        context.insert(tag)
        return tag
    }

    static func rename(_ tag: Tag, to newName: String) {
        tag.name = newName.trimmingCharacters(in: .whitespaces)
    }

    static func recolor(_ tag: Tag, to colorName: String) {
        tag.colorName = colorName
    }

    static func delete(_ tag: Tag, in context: ModelContext) {
        context.delete(tag)
    }
}
