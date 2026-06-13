import SwiftUI
import SwiftData

struct MealTagEditor: View {
    @Bindable var meal: MealLog
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Tag.name) private var allTags: [Tag]

    @State private var isBrowsing = false   // showing existing pills + "+"
    @State private var isCreating = false   // showing text field + colors

    @State private var draftName = ""
    @State private var draftColor = Tag.palette.first ?? "color_fruits"

    var body: some View {
        Group {
            if let tag = meal.tags.first {
                TagPill(tag: tag) { meal.tags.removeAll() }
            } else if isCreating {
                creatingRow

            } else if isBrowsing {
                browsingRow //existing tags

            } else {
                addTagButton //default
            }
        }
    }

    private var addTagButton: some View {
        Button {
            if allTags.isEmpty {
                // No tags yet — go straight to create
                draftName = ""
                isCreating = true
            } else {
                // Tags exist — show them first
                isBrowsing = true
            }
        } label: {
            Label("Add Tag", systemImage: "tag")
                .font(.system(.caption, weight: .medium))
                .padding(.horizontal, 8).padding(.vertical, 6)
                .background(Color(.systemBackground))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color(.systemGray4), lineWidth: 0.5))
        }
        .buttonStyle(.plain)
    }

    private var browsingRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                // Existing tags as tappable pills
                ForEach(allTags) { tag in
                    Button {
                        meal.tags = [tag]
                        isBrowsing = false
                    } label: {
                        TagPill(tag: tag)
                    }
                    .buttonStyle(.plain)
                }

                // "+" to create a brand new tag
                Button {
                    isBrowsing = false
                    draftName = ""
                    isCreating = true
                } label: {
                    Image(systemName: "plus")
                        .font(.body).bold()
                        .foregroundColor(.primary)
                        .padding(.horizontal, 4)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var creatingRow: some View {
        HStack(spacing: 8) {
            EditableTagPill(
                text: $draftName,
                tint: Color(draftColor),
                onCommit: commit
            )
            colorPicker
            Button {
                isCreating = false
                draftName = ""
            } label: {
                Image(systemName: "xmark")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(6)
            }
            .buttonStyle(.plain)
        }
    }

    private var colorPicker: some View {
        HStack(spacing: 8) {
            ForEach(Tag.palette, id: \.self) { name in
                Circle()
                    .fill(Color(name))
                    .frame(width: 20, height: 20)
                    .contentShape(Circle())
                    .overlay(Circle().stroke(Color.primary,
                        lineWidth: draftColor == name ? 2 : 0))
                    .onTapGesture { draftColor = name }
            }
        }
    }

    private func commit() {
        let name = draftName.trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty else { isCreating = false; return }
        let tag = TagStorage.findOrCreate(name: name, colorName: draftColor, in: modelContext)
        meal.tags = [tag]
        isCreating = false
        draftName = ""
    }
}

#Preview("MealTagEditor") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: MealLog.self, Tag.self, configurations: config)

    let t1 = Tag(name: "Healthy", colorName: "color_fruits")
    let t2 = Tag(name: "High Fiber", colorName: "color_vegetables")
    let t3 = Tag(name: "Dinner", colorName: "color_herbs")
    [t1, t2, t3].forEach { container.mainContext.insert($0) }

    let noTagMeal  = MealLog(confirmedPlants: [])
    let hasTagMeal = MealLog(confirmedPlants: [], tags: [t1])
    [noTagMeal, hasTagMeal].forEach { container.mainContext.insert($0) }

    return VStack(alignment: .leading, spacing: 24) {
        Text("No tag (tags exist) → tap Add Tag → see pills").font(.caption2).foregroundColor(.secondary)
        MealTagEditor(meal: noTagMeal)

        Divider()

        Text("Has tag → tap to re-edit").font(.caption2).foregroundColor(.secondary)
        MealTagEditor(meal: hasTagMeal)
    }
    .padding()
    .modelContainer(container)
}
