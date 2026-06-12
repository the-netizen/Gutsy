import SwiftUI

struct CapturedMeal: Identifiable { //to make sure image is captured
    let id = UUID()
    let image: UIImage
}

struct CameraButton: View {
    let onFinish: (Set<SuperSixGroups>) -> Void
    
    @State private var showCamera = false
    @State private var capturedImage: UIImage? = nil
    @State private var mealToProcess: CapturedMeal? = nil

    
    var body: some View {
        ZStack {
            Button {
                showCamera = true
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(.accentColor)
                        .frame(width: 60, height: 60)
                        .shadow(color: .pink.opacity(0.4), radius: 8, y: 4)
                    Image(systemName: "plus")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
            .padding(.bottom, 30)
        }
        // Camera stays a cover — it's a modal UIKit controller
        .fullScreenCover(isPresented: $showCamera, onDismiss: startFlowIfCaptured) {
            CameraPicker(selectedImage: $capturedImage, isPresented: $showCamera)
                .ignoresSafeArea()
        }
        // only present if meal captured
        .fullScreenCover(item: $mealToProcess) { meal in
            MealCaptureFlow(image: meal.image) { newGroups in
                mealToProcess = nil
                onFinish(newGroups)
            }
        }
    }
    private func startFlowIfCaptured() {
        guard let image = capturedImage else {
            return
        } //nth happens when user cancels camera
       mealToProcess = CapturedMeal(image: image)
       capturedImage = nil //reset for next capture
    }
}
#Preview("Camera Button") {
    CameraButton(onFinish: { _ in })
        .background(Color.bg)
}
