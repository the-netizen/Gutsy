import SwiftUI
import SwiftData

struct TagFilterRow: View {
    let tag: Tag
    let isSelected: Bool
    let onToggle: () -> Void
    let onEdit: () -> Void

    var body: some View {
        HStack (spacing: 15){
            Button(action: onToggle) {
                HStack{
                    Image(systemName: "tag").font(.caption2)
                    Text(tag.name)
                        .font(.system(.caption, weight: .medium))
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer(minLength: 0) // pill hugs left
                }
                .foregroundColor(.primary)
                .padding(.horizontal, 10).padding(.vertical, 6)
//                .frame(maxWidth: .infinity)   // dynamic text
                .background(tag.color.opacity(isSelected ? 0.9 : 0.3))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(tag.color, lineWidth: 1))
            }
            .buttonStyle(.plain)

            Button(action: onEdit) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.system(.body, weight: .bold))
            }
            .buttonStyle(.plain)
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
    }
}

#Preview("TagFilterRow States") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Tag.self, configurations: config)

    let t1 = Tag(name: "Healthy Meal",   colorName: "color_fruits")
    let t2 = Tag(name: "High in fruits", colorName: "color_vegetables")
    let t3 = Tag(name: "small",          colorName: "color_wholegrains")
    let t4 = Tag(name: "High in Fiber",  colorName: "color_herbs")
    [t1, t2, t3, t4].forEach { container.mainContext.insert($0) }

    return VStack(alignment: .leading, spacing: 12) {
        TagFilterRow(tag: t1, isSelected: true,  onToggle: {}, onEdit: {})
        TagFilterRow(tag: t2, isSelected: false, onToggle: {}, onEdit: {})
        TagFilterRow(tag: t3, isSelected: true, onToggle: {}, onEdit: {})
        TagFilterRow(tag: t4, isSelected: false, onToggle: {}, onEdit: {})
    }
//    .frame(width: 240)
//    .padding()
    .background(Color(.systemGray6))
    .modelContainer(container)
}
