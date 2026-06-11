import SwiftUI

struct CameraButton: View {
    let onFinish: () -> Void
    @State private var showFlow = false
    
    @State private var showCamera = false
    @State private var capturedImage: UIImage? = nil
    
    var body: some View {
        ZStack {
            //            Spacer()
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
        // 2. Flow (loading → review) — presented only after camera is gone
        .fullScreenCover(isPresented: $showFlow) {
            MealCaptureFlow(image: capturedImage) {
                showFlow = false
                onFinish()
            }
        }
        
        //    private func handleDismiss() {
        //        guard let image = capturedImage else { return }
        //        flow.didCaptureImage(image)
        //    }
    }
    private func startFlowIfCaptured() {
        // If user cancelled camera there's no image — don't start the flow
        if capturedImage != nil { showFlow = true }
    }
}
#Preview("Camera Button") {
    CameraButton(onFinish: {})
        .background(Color.bg) // optional if you have a custom background color
//        .padding()
}
