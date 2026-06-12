import SwiftUI
import SwiftData

struct TagPill: View {
    let tag: Tag
    var onRemove: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "tag").font(.caption2)
            Text(tag.name)
                .font(.system(.caption2, weight: .medium))
                .lineLimit(1)
                .truncationMode(.tail)
            if let onRemove {
                Button(action: onRemove) {
                    Image(systemName: "xmark").font(.system(.caption2, weight: .bold))
                }.buttonStyle(.plain)
            }
        }
        .foregroundColor(.primary)
        .padding(.horizontal, 8).padding(.vertical, 6)
        .background(
                Capsule()
                    .fill(Color(.white).opacity(0.95)) //white
                    .overlay(Capsule().fill(tag.color.opacity(0.4)))  // tag color
            )
            .overlay(Capsule().stroke(tag.color, lineWidth: 1.5)) // border
            .dynamicTypeSize(...DynamicTypeSize.accessibility1)
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
    }
}

// Selectable chip for the filter bar
struct TagFilterChip: View {
    let tag: Tag
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(tag.name)
                .font(.system(.caption2, weight: .medium))
                .foregroundColor(.primary)
                .padding(.horizontal, 8).padding(.vertical, 6)
                .background(tag.color.opacity(isSelected ? 0.9 : 0.25))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(tag.color, lineWidth: 1))
        }
        .buttonStyle(.plain)
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
    }
}

// Editing variant
struct EditableTagPill: View {
    @Binding var text: String
    var placeholder: String = "Add Tag"
    var tint: Color? = nil                       // ← new optional
    let onCommit: () -> Void
    @FocusState private var focused: Bool

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "tag").font(.caption2)
            TextField(placeholder, text: $text)
                .font(.system(.caption2, weight: .medium))
                .focused($focused)
                .fixedSize()
                .onSubmit(onCommit)
                .onChange(of: text) { _, newValue in
                    if newValue.count > Tag.maxNameLength {
                        text = String(newValue.prefix(Tag.maxNameLength))
                    }
                }
        }
        .foregroundColor(.primary)
        .padding(.horizontal, 8).padding(.vertical, 6)
        .background((tint ?? Color(.systemBackground)).opacity(tint == nil ? 1 : 0.35))   // ← tinted when supplied in edit mode
        .clipShape(Capsule())
        .overlay(Capsule().stroke(tint ?? Color(.systemGray4), lineWidth: tint == nil ? 0.5 : 1))
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
