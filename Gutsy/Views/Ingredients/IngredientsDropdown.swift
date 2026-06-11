import SwiftUI

struct IngredientsDropdown: View {
    let suggestions: [String]
    let onSelect: (String) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(suggestions.enumerated()), id: \.element) { index, name in
                Button {
                    onSelect(name)
                } label: {
                    HStack {
                        Text(name)
                            .font(.body)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .contentShape(Rectangle())   // whole row is tappable
                }
                .buttonStyle(SuggestionRowStyle())

                if index < suggestions.count - 1 {
                    Divider().padding(.horizontal, 12)
                }
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
    }
}

// Turns the tapped row pink as feedback
private struct SuggestionRowStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.accentColor.opacity(0.18) : Color.clear)
    }
}

#Preview {
    IngredientsDropdown(
        suggestions: ["Apple", "Almonds", "Avocado", "Asparagus"],
        onSelect: { _ in }
    )
    .padding()
    .background(Color(.systemGray6))
}
