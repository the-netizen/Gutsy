import SwiftUI
import SwiftData

struct IngredientsEditor: View {
    @Bindable var meal: MealLog

    @State private var isEditing = false
    @State private var draft = ""
    @State private var showPicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            header

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(meal.confirmedPlants, id: \.name) { plant in
                        IngredientBox(
                            plant: plant,
                            onDelete: isEditing ? { delete(plant) } : nil
                        )
                    }
                    if isEditing { addTile }
                }
            }

            if showPicker { picker }
        }
    }

    private var header: some View {
        HStack {
            Text("Ingredients").font(.headline)
            Spacer()
            Button {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isEditing.toggle()
                    if !isEditing { showPicker = false; draft = "" }
                }
            } label: {
                Image(systemName: isEditing ? "checkmark" : "pencil")
                    .font(.system(.body, weight: .semibold))
                    .padding(10)
                    .background(Color(.systemBackground))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color(.systemGray4), lineWidth: 0.5))
            }
            .buttonStyle(.plain)
        }
    }

    private var addTile: some View {
        Button {
            draft = ""
            showPicker = true
        } label: {
            Image(systemName: "plus")
                .font(.title2)
                .foregroundColor(.pink)
                .frame(width: 150, height: 150)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4]))
                        .foregroundColor(Color(.systemGray3))
                )
        }
        .buttonStyle(.plain)
    }

    private var picker: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Type to search ingredients…", text: $draft)
                .font(.subheadline)
                .padding(.horizontal, 12).padding(.vertical, 10)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.systemGray4), lineWidth: 0.5))

            let suggestions = PlantDB.shared.suggestions(matching: draft)
            if !suggestions.isEmpty {
                IngredientsDropdown(suggestions: suggestions) { add(named: $0) }
            }
        }
        .padding(.top, 10)
    }

    private func delete(_ plant: Plants) {
        meal.confirmedPlants.removeAll { $0.name == plant.name }
        regenerateInsight()
    }

    private func add(named name: String) {
        guard let plant = PlantDB.shared.lookup(name),
              !meal.confirmedPlants.contains(where: { $0.name.lowercased() == plant.name.lowercased() }) else {
            draft = ""; showPicker = false; return
        }
        meal.confirmedPlants.append(plant)
        draft = ""; showPicker = false
        regenerateInsight()
    }

    private func regenerateInsight() {
        let names = meal.confirmedPlants.map { $0.name }
        Task {
            if let insight = try? await Service.shared.generateInsight(for: names) {
                await MainActor.run { meal.mealInsight = insight }
            }
        }
    }
}

#Preview("IngredientsEditor") {
    // In-memory SwiftData container for previews
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: MealLog.self, Tag.self, configurations: config)

    // Mock meal with some plants
    let mockMeal = MealLog(confirmedPlants: [
        Plants(name: "Strawberry", group: "Fruits", benefit: "Rich in vitamin C and antioxidants."),
        Plants(name: "Cauliflower", group: "Vegetables", benefit: "High in fibre and vitamins."),
        Plants(name: "Rice", group: "Wholegrains", benefit: "Provides carbohydrates for energy.")
    ])
    container.mainContext.insert(mockMeal)

    return VStack(alignment: .leading, spacing: 16) {
        IngredientsEditor(meal: mockMeal)
            .padding()
        Spacer()
    }
    .background(Color(.systemGroupedBackground))
    .modelContainer(container)
}
