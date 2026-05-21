import SwiftUI

struct IngredientCard: View {
    let ingredient: Ingredient
    let isEditing: Bool
    @Binding var draftName: String //temp name while editing
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onSave: () -> Void

    // Automatically focuses the TextField when editing starts
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            if isEditing {
                // Editable mode — TextField replaces Text
                TextField("Ingredient name", text: $draftName)
                    .font(.body)
                    .focused($isFocused)
                    .onAppear { isFocused = true }   // cursor appears immediately
                    .onSubmit { onSave() }            // keyboard return saves
            } else {
                // Display mode
                Text(ingredient.name)
                    .font(.body)
                    .foregroundColor(.primary)
            }

            Spacer()

            if isEditing {
                // Checkmark to confirm edit
                Button(action: onSave) {
                    Image(systemName: "checkmark")
                        .foregroundColor(.pink)
                        .font(.body)
                }
                .buttonStyle(.plain)
            } else {
                // Pencil to start edit
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .foregroundColor(.secondary)
                        .font(.body)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: onDelete) {
                Label("", systemImage: "trash")
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        IngredientCard(
            ingredient: Ingredient(name: "Tomato"),
            isEditing: false,
            draftName: .constant(""),
            onEdit: {},
            onDelete: {},
            onSave: {}
        )
        IngredientCard(
            ingredient: Ingredient(name: "Tomato"),
            isEditing: true,
            draftName: .constant("Tomato"),
            onEdit: {},
            onDelete: {},
            onSave: {}
        )
    }
    .padding()
    .background(Color(.systemGray6))
}
