import SwiftUI
import SwiftData

struct MealCaptureFlow: View {
    let image: UIImage?
    let onFinish: () -> Void          // host decides what "done" means

    @State private var detectedIngredients: [String]? = nil   // nil = still analyzing
    @State private var errorMessage: String? = nil

    var body: some View {
        Group {
            if let ingredients = detectedIngredients {
                IngredientReviewView(
                    vm: IngredientsReviewVM(
                        detectedNames: ingredients,
                        capturedImage: image
                    ),
                    onConfirm: onFinish      // confirm = done
                )
            } else {
                LoadingView()                // always shown while analyzing
            }
        }
        .task { await analyze() }            // runs once when this view appears
        .alert("Something went wrong", isPresented: .constant(errorMessage != nil)) {
            Button("OK") { onFinish() }
        } message: {
            Text(errorMessage ?? "")
        }
    }

    private func analyze() async {
        print("🟡 MealCaptureFlow.analyze() started")

        guard let image else {
            print("🔴 image is NIL — flow got no photo, will hang on loading")
            errorMessage = "No photo was captured."
            return
        }
        print("🟢 have image, size:", image.size)

        do {
            let result = try await Service.shared.extractIngredients(from: image)
            print("🟢 AI returned \(result.count) ingredients:", result)
            detectedIngredients = result
        } catch {
            print("🔴 AI call failed:", error)
            errorMessage = error.localizedDescription
        }
    }
}
