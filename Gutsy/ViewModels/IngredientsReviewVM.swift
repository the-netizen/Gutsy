import Foundation
import UIKit
import SwiftData
internal import Combine

@MainActor
class IngredientsReviewVM: ObservableObject {
    @Published var ingredients: [Ingredient]
    @Published var editingIngredientID: UUID? = nil  // which card is in edit mode
    @Published var isAddingNew = false  // controls inline add card
    @Published var draftName = "" // temp editing/adding names
    private let capturedImage: UIImage?

    init(detectedNames: [String], capturedImage: UIImage? = nil) {
        self.ingredients = detectedNames.map { Ingredient(name: $0.capitalized) }
        self.capturedImage = capturedImage
    }

      /// Editing

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

    /// Adding
    
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

    var suggestions: [String] {
        PlantDB.shared.suggestions(matching: draftName)
    }

    func selectSuggestion(_ name: String) { // tapping suggestion fills the field
        draftName = name
        if isAddingNew {
            confirmAdd()
        } else if editingIngredientID != nil {
            saveEdit()
        }
    }

      func delete(_ ingredient: Ingredient) {
          ingredients.removeAll { $0.id == ingredient.id }
      }

    /// Confirm and Save ingredients
    
    func save(using context: ModelContext) {
            // 1. Match confirmed ingredient names against plant database
            let confirmedPlants = PlantDB.shared.filterPlants(
                from: ingredients.map { $0.name.lowercased() }
            )
            print("✅ Matched plants:", confirmedPlants.map { "\($0.name) → \($0.group)" })

            // 2. Save image to device file system — returns path string
            let imagePath: String?
            if let image = capturedImage {
                imagePath = ImageStorage.save(image)
            } else {
                imagePath = nil
            }

            // 3. Create the MealLog with all data
            let log = MealLog(
                date: .now,
                imagePath: imagePath,
                confirmedPlants: confirmedPlants
            )

            // 4. Insert into SwiftData — persists to device storage
            context.insert(log)
            print("✅ MealLog saved: \(confirmedPlants.count) plants, image: \(imagePath ?? "none")")
        }
  }
