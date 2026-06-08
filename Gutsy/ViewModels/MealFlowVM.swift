//import SwiftUI
//import SwiftData
//internal import Combine
//
//@MainActor
//class MealFlowVM: ObservableObject {
//
//    // Navigation path — drives camera → loading → review
//    @Published var path = NavigationPath()
//
//    // Flow data
//    @Published var capturedImage: UIImage? = nil
//    @Published var detectedIngredients: [String] = []
//    @Published var errorMessage: String? = nil
//
//    // Controls the celebration popup on Main after saving
//    @Published var showDiversityPopup = false
//
//    private var hasAnalyzed = false
//
//    // The steps that get pushed onto the path
//    enum Step: Hashable {
//        case loading
//        case review
//    }
//
//
//    // Called after camera dismisses with a photo
//    func didCaptureImage(_ image: UIImage) {
//        guard !hasAnalyzed else { return }
//        hasAnalyzed = true
//        capturedImage = image
//        path.append(Step.loading)   // push loading page
//        analyze(image)
//    }
//
//    private func analyze(_ image: UIImage) {
//        Task {
//            do {
//                let ingredients = try await Service.shared.extractIngredients(from: image)
//                detectedIngredients = ingredients
//                // Replace loading with review
//                path.removeLast()
//                path.append(Step.review)
//            } catch {
//                path.removeLast()   // pop loading
//                errorMessage = error.localizedDescription
//            }
//        }
//    }
//
//    // Called when user confirms ingredients on review page
//    func didConfirm() {
//        // Reset the flow — pops everything back to Main
//        path = NavigationPath()
//        capturedImage = nil
//        hasAnalyzed = false
//        // Trigger the celebration popup on Main
//        showDiversityPopup = true
//    }
//
//    // Resets without saving (e.g. user backs out)
//    func reset() {
//        path = NavigationPath()
//        capturedImage = nil
//        hasAnalyzed = false
//    }
//}
