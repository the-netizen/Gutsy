import SwiftUI
import SwiftData

struct TagFilterPanel: View {
    let allTags: [Tag]
    @Bindable var filter: TagFilterState        // bound from parent
    @Environment(\.modelContext) private var modelContext

    @State private var editingTag: Tag? = nil   // nil = list mode, else edit mode

    var body: some View {
        Group {
            if let tag = editingTag {
                TagEdit(tag: tag, onBack: { editingTag = nil })
            } else {
                listView
            }
        }
        .frame(width: 150)
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.15), radius: 12, y: 4)
    }

    private var listView: some View {
        VStack(spacing: 8) {
            if allTags.isEmpty {
                Text("No tags yet")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 16)
            } else {
                ForEach(allTags, id: \.id) { tag in
                    TagFilterRow(
                        tag: tag,
                        isSelected: filter.isSelected(tag),
                        onToggle: { filter.toggle(tag) },
                        onEdit:   { editingTag = tag }
                    )
                }
            }

            if filter.isFiltering {
                Button("Clear") { filter.clear() }
                    .font(.caption)
                    .padding(.top, 4)
            }
        }
    }
}

#Preview("Panel — list mode") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Tag.self, configurations: config)

    let tags = [
        Tag(name: "Healthy Meal",   colorName: "color_fruits"),
        Tag(name: "High in fruits", colorName: "color_vegetables"),
        Tag(name: "High in Fiber",  colorName: "color_herbs"),
        Tag(name: "Tiny",           colorName: "color_nuts"),
    ]
    tags.forEach { container.mainContext.insert($0) }

    let filter = TagFilterState()
    filter.selectedNames.insert("Healthy Meal")

    return TagFilterPanel(allTags: tags, filter: filter)
        .padding()
        .background(Color(.systemGray6))
        .modelContainer(container)
}
