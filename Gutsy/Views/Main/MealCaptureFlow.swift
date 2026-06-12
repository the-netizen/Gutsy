import SwiftUI
import SwiftData
struct MealCaptureFlow: View {
    let image: UIImage                 // ← non-optional now
    let onFinish: () -> Void

    @State private var detectedIngredients: [String]? = nil
    @State private var errorMessage: String? = nil

    var body: some View {
        Group {
            if let ingredients = detectedIngredients {
                IngredientReviewView(
                    vm: IngredientsReviewVM(detectedNames: ingredients, capturedImage: image),
                    onConfirm: onFinish
                )
            } else {
                LoadingView()
            }
        }
        .task { await analyze() }
        .alert("Something went wrong", isPresented: .constant(errorMessage != nil)) {
            Button("OK") { onFinish() }
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
