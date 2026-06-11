import SwiftUI
import SwiftData

struct TagEdit: View {
    @Bindable var tag: Tag
    let onBack: () -> Void
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack {
            // editing tag
            HStack{
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
                EditableTagPill(text: $tag.name, tint: tag.color) { /* commit on submit */ }
                
                Spacer()
            }

            // Color swatches
            HStack(spacing: 5) {
                ForEach(Tag.palette, id: \.self) { name in
                    Circle()
                        .fill(Color(name))
                        .frame(width: 25, height: 25)
                        .contentShape(Circle())
                        .overlay(
                            Circle().stroke(Color.primary, lineWidth: tag.colorName == name ? 2 : 0)
                        )
                        .onTapGesture { TagStorage.recolor(tag, to: name) }
                }
            }.padding(.bottom, 15).padding(.top, 15)

            // delete button
            Button(role: .destructive) {
                TagStorage.delete(tag, in: modelContext)
                onBack()
            } label: {
                Label("Delete", systemImage: "trash")
                    .font(.subheadline.weight(.medium))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.red.opacity(0.8))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
//        .padding()
    }
}

#Preview("TagEdit") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Tag.self, configurations: config)

    let sample = Tag(name: "Healthy Meal", colorName: Tag.palette.first ?? "color_fruits")
    container.mainContext.insert(sample)

    return TagEdit(tag: sample, onBack: {})
        .modelContainer(container)
        .padding()
        .background(Color(.systemGray6))
}
