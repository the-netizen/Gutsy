import SwiftUI
import SwiftData

struct MealDeleteButton: View {
    let meal: MealLog
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showConfirm = false

    var body: some View {
        Button(role: .destructive) {
            showConfirm = true
        } label: {
            Label("Delete Log", systemImage: "trash")
                .font(.subheadline.weight(.medium))
                .foregroundColor(.white)
                .padding(.vertical, 10).padding(.horizontal, 20)
                .background(Color.red.opacity(0.85))
                .clipShape(Capsule())
        }
        .alert("Delete this meal?", isPresented: $showConfirm) {
            Button("Delete", role: .destructive) {
                if let filename = meal.imagePath {
                    ImageStorage.delete(filename: filename)
                }
                modelContext.delete(meal)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This can't be undone.")
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 30)
    }
}

#Preview {
    // In-memory SwiftData container for previews
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: MealLog.self, Tag.self, configurations: config)

    // Mock meal to preview deletion UI
    let mockMeal = MealLog(
        confirmedPlants: [
            Plants(name: "Strawberry", group: "Fruits", benefit: "Rich in vitamin C.")
        ],
        tags: []
    )
    container.mainContext.insert(mockMeal)

    return VStack {
        MealDeleteButton(meal: mockMeal)
            .padding()
        Spacer()
    }
    .background(Color(.systemGroupedBackground))
    .modelContainer(container)
}
