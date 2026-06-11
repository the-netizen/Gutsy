import SwiftUI
import SwiftData

struct TagPill: View {
    let tag: Tag
    var onRemove: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "tag").font(.system(size: 10))
            Text(tag.name).font(.system(.caption, weight: .medium))
            if let onRemove {
                Button(action: onRemove) {
                    Image(systemName: "xmark").font(.system(.caption2, weight: .bold))
                }.buttonStyle(.plain)
            }
        }
        .foregroundColor(.primary)
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(tag.color.opacity(0.35))               // real tag color
        .clipShape(Capsule())
        .overlay(Capsule().stroke(tag.color, lineWidth: 1))
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
    }
}

// Selectable chip for the filter bar — filled when active
struct TagFilterChip: View {
    let tag: Tag
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(tag.name)
                .font(.system(.caption, weight: .medium))
                .foregroundColor(.primary)
                .padding(.horizontal, 12).padding(.vertical, 6)
                .background(tag.color.opacity(isSelected ? 0.9 : 0.25))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(tag.color, lineWidth: 1))
        }
        .buttonStyle(.plain)
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
    }
}

// Editing variant — for typing a new tag name (no color yet)
struct EditableTagPill: View {
    @Binding var text: String
    var placeholder: String = "Add Tag"
    let onCommit: () -> Void
    @FocusState private var focused: Bool

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "tag").font(.system(size: 10))
            TextField(placeholder, text: $text)
                .font(.system(.caption, weight: .medium))
                .focused($focused)
                .fixedSize()
                .onSubmit(onCommit)
        }
        .foregroundColor(.primary)
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(Color(.systemBackground))
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color(.systemGray4), lineWidth: 0.5))
        .onAppear { focused = true }
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Tag.self, configurations: config)
    let tag = Tag(name: "Healthy Meal", colorName: "color_fruits")
    container.mainContext.insert(tag)

    return VStack(spacing: 8) {
        TagPill(tag: tag)
        TagPill(tag: tag, onRemove: {})
        TagFilterChip(tag: tag, isSelected: true, onTap: {})
    }
    .padding()
    .background(Color(.systemGray6))
    .modelContainer(container)
}
