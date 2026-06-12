import SwiftUI

struct IngredientBox: View {
    let plant: Plants
    var onDelete: (() -> Void)? = nil

    private var headerColor: Color {
        plant.groupEnum?.color ?? Color(.systemGray4)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 4) {
                Text(plant.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Spacer()
                if let onDelete {
                    Button(action: onDelete) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary.opacity(0.6))
                            .font(.body)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(headerColor)

            Text(plant.benefit)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(12)

            Spacer(minLength: 0)
        }
        .frame(width: 150)
        .frame(minHeight: 150)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray5), lineWidth: 1))
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }
}

struct AddIngredientBox: View {
    @Binding var draft: String
    let suggestions: [String]
    let onSelect: (String) -> Void
    let onCancel: () -> Void

    @FocusState private var focused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Header — same layout as IngredientBox, text field instead of name
            HStack(spacing: 4) {
                TextField("Search…", text: $draft)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.primary)
                    .focused($focused)
                Spacer()
                Button(action: onCancel) {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary.opacity(0.6))
                        .font(.body)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray5)) //no group yet

            // suggestions fill the space where benefit text would be
            if suggestions.isEmpty {
                Text(draft.isEmpty ? "Start typing…" : "No match")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(12)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(suggestions.prefix(4).enumerated()), id: \.element) { i, name in
                        Button {
                            onSelect(name)
                        } label: {
                            Text(name)
                                .font(.caption)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)

                        if i < min(suggestions.count, 4) - 1 {
                            Divider().padding(.horizontal, 8)
                        }
                    }
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
        .frame(width: 150)
        .frame(minHeight: 150)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray4), lineWidth: 1))
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
        .onAppear { focused = true }
    }
}

#Preview("Display") {
    HStack(spacing: 12) {
        IngredientBox(plant: Plants(name: "Strawberry", group: "Fruits",
            benefit: "Rich in vitamin C and antioxidants that support immunity and health."))
        IngredientBox(plant: Plants(name: "Coffee", group: "Herbs & Spices",
            benefit: "Contains caffeine and antioxidants that boost energy and focus."),
            onDelete: {})
    }
    .padding()
    .background(Color(.systemGray6))
}

#Preview("Adding") {
    HStack(spacing: 12) {
        IngredientBox(plant: Plants(name: "Strawberry", group: "Fruits",
            benefit: "Rich in vitamin C and antioxidants."))
        AddIngredientBox(
            draft: .constant("tom"),
            suggestions: ["Tomato", "Tomatillo"],
            onSelect: { _ in },
            onCancel: {}
        )
    }
    .padding()
    .background(Color(.systemGray6))
}
