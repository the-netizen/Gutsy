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
    
    func save(using context: ModelContext) -> Set<SuperSixGroups> {
        let confirmedPlants = PlantDB.shared.filterPlants(
            from: ingredients.map { $0.name.lowercased() }
        )

        // Snapshot this week's plants BEFORE inserting
        let weekStart = Calendar.current.dateInterval(of: .weekOfYear, for: Date())?.start ?? .distantPast
        let descriptor = FetchDescriptor<MealLog>(predicate: #Predicate { $0.date >= weekStart })
        let existingThisWeek = (try? context.fetch(descriptor)) ?? []
        let existingPlantNames = Set(
            existingThisWeek.flatMap { $0.confirmedPlants }.map { $0.name.lowercased() }
        )

        // unique plants this week
        let newPlants = confirmedPlants.filter {
            !existingPlantNames.contains($0.name.lowercased())
        }
        // Groups of the new plants — for which bacteria to float
        let celebratedGroups = Set(newPlants.compactMap { SuperSixGroups(rawValue: $0.group) })
        print("✨ New plants this week:", newPlants.map { $0.name })

        // Save image + meal
        let imagePath = capturedImage.flatMap { ImageStorage.save($0) }
        let log = MealLog(date: .now, imagePath: imagePath, confirmedPlants: confirmedPlants)
        context.insert(log)

        let names = confirmedPlants.map { $0.name }
        Task {
            if let insight = try? await Service.shared.generateInsight(for: names) {
                await MainActor.run { log.mealInsight = insight }
            }
        }

        print("✅ MealLog saved: \(confirmedPlants.count) plants total, \(newPlants.count) new")
        // Return groups-of-new-plants. Empty = no new plant = no score increase = no popup.
        return celebratedGroups
    }//save
  }
