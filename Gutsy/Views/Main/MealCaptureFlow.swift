import SwiftUI
import SwiftData
struct MealCaptureFlow: View {
    let image: UIImage
    let onFinish: (Set<SuperSixGroups>) -> Void   // ← carries new groups

    @State private var detectedIngredients: [String]? = nil
    @State private var errorMessage: String? = nil

    var body: some View {
        Group {
            if let ingredients = detectedIngredients {
                IngredientReviewView(
                    vm: IngredientsReviewVM(detectedNames: ingredients, capturedImage: image),
                    onConfirm: { newGroups in onFinish(newGroups) }
                )
            } else {
                LoadingView()
            }
        }
        .task { await analyze() }
        .alert("Something went wrong", isPresented: .constant(errorMessage != nil)) {
            Button("OK") { onFinish([]) }    // empty set = no popup
        } message: {
            Text(errorMessage ?? "")
        }
    }

    private func analyze() async {
        do {
            detectedIngredients = try await Service.shared.extractIngredients(from: image)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
