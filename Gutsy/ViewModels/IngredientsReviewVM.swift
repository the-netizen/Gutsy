import Foundation
internal import Combine

@MainActor
class IngredientsReviewVM: ObservableObject {
    @Published var ingredients: [Ingredient]
    @Published var editingIngredientID: UUID? = nil  // which card is in edit mode
    @Published var isAddingNew = false  // controls inline add card
    @Published var draftName = "" // temp editing/adding names
    init(detectedNames: [String]) {
          self.ingredients = detectedNames.map { Ingredient(name: $0.capitalized) }
      }

      // MARK: - Edit existing

      func startEditing(_ ingredient: Ingredient) {
          cancelAdd()                          // close add card if open
          editingIngredientID = ingredient.id
          draftName = ingredient.name          // pre-fill with current name
      }

      func saveEdit() {
          guard let id = editingIngredientID,
                !draftName.trimmingCharacters(in: .whitespaces).isEmpty else {
              cancelEdit()
              return
          }
          if let index = ingredients.firstIndex(where: { $0.id == id }) {
              ingredients[index].name = draftName.capitalized
          }
          cancelEdit()
      }

      func cancelEdit() {
          editingIngredientID = nil
          draftName = ""
      }

      func showAddCard() {
          cancelEdit()                         // close edit mode if open
          isAddingNew = true
          draftName = ""
      }

      func confirmAdd() {
          let trimmed = draftName.trimmingCharacters(in: .whitespaces)
          guard !trimmed.isEmpty else {
              cancelAdd()
              return
          }
          ingredients.append(Ingredient(name: trimmed.capitalized))
          cancelAdd()
      }

      func cancelAdd() {
          isAddingNew = false
          draftName = ""
      }

      func delete(_ ingredient: Ingredient) {
          ingredients.removeAll { $0.id == ingredient.id }
      }

      func confirmIngredients() -> [Plants] {
          let matched = PlantDB.shared.filterPlants(
              from: ingredients.map { $0.name.lowercased() }
          )
          print("✅ Matched plants:", matched.map { "\($0.name) → \($0.group)" })
          return matched
      }
  }
