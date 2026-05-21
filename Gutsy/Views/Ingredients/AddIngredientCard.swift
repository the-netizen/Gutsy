import SwiftUI

struct AddIngredientCard: View {
    @Binding var name: String
    let onConfirm: () -> Void   // called on Enter

    @FocusState private var isFocused: Bool

    var body: some View {
        TextField("Type ingredient name...", text: $name)
            .font(.body)
            .focused($isFocused)
            .onAppear { isFocused = true }  // cursor appears immediately
            .onSubmit { onConfirm() }        // Enter key confirms
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}

#Preview("Add ingredient") {
    VStack(spacing: 12) {
        AddIngredientCard(
            name: .constant("Spinach"),
            onConfirm: {},
        )
    }
    .padding()
    .background(Color(.systemGray6))
}
