import SwiftUI
import SwiftData

struct MealTagEditor: View {
    @Bindable var meal: MealLog
    @Environment(\.modelContext) private var modelContext

    @State private var isEditing = false
    @State private var draftName = ""
    @State private var draftColor = Tag.palette.first ?? "color_fruits"

    var body: some View {
        if let tag = meal.tags.first, !isEditing {
            TagPill(tag: tag) { meal.tags.removeAll() }
        } else if isEditing {
            HStack(spacing: 8) {
                EditableTagPill(text: $draftName, tint: Color(draftColor)) { commit() }
                colorPicker
            }
        } else {
            Button {
                draftName = ""
                isEditing = true
            } label: {
                Label("Add Tag", systemImage: "tag")
                    .font(.system(.caption, weight: .medium))
                    .padding(.horizontal, 10).padding(.vertical, 6)
                    .background(Color(.systemBackground))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color(.systemGray4), lineWidth: 0.5))
            }
            .buttonStyle(.plain)
        }
    }

    private var colorPicker: some View {
        HStack(spacing: 8) {
            ForEach(Tag.palette, id: \.self) { name in
                Circle()
                    .fill(Color(name))
                    .frame(width: 22, height: 22)
                    .contentShape(Circle())
                    .overlay(Circle().stroke(Color.primary, lineWidth: draftColor == name ? 2 : 0))
                    .onTapGesture { draftColor = name }
            }
        }
    }

    private func commit() {
        let name = draftName.trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty else { isEditing = false; return }
        let tag = TagStorage.findOrCreate(name: name, colorName: draftColor, in: modelContext)
        meal.tags = [tag]
        isEditing = false
    }
}

#Preview("MealTagEditor") {
    // In-memory SwiftData container for previews
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: MealLog.self, Tag.self, configurations: config)

    // Mock meals
    let mealWithoutTag = MealLog(confirmedPlants: [])
    let existingTag = Tag(name: "High Fiber", colorName: Tag.palette.first ?? "color_fruits")
    let mealWithTag = MealLog(confirmedPlants: [], tags: [existingTag])

    container.mainContext.insert(mealWithoutTag)
    container.mainContext.insert(mealWithTag)

    return VStack(alignment: .leading, spacing: 20) {
        Text("No Tag").font(.headline)
        MealTagEditor(meal: mealWithoutTag)

        Divider().padding(.vertical, 8)

        Text("With Tag").font(.headline)
        MealTagEditor(meal: mealWithTag)
    }
    .padding()
    .modelContainer(container)
}
