import SwiftUI

struct CameraButton: View {
    
    // Controls showing the camera sheet
    @State private var showCamera = false
    
    // Holds the photo taken
    @State private var capturedImage: UIImage? = nil
    
    // Controls showing the ingredient review sheet
    @State private var showIngredientReview = false
    
    // The ingredients Gemini detected
    @State private var detectedIngredients: [String] = []
    
    // Loading state while AI is working
    @State private var isAnalyzing = false
    
    // Error handling
    @State private var errorMessage: String? = nil
    @State private var hasAnalyzed = false
    
    var body: some View {
        ZStack {
            // Loading overlay — shows while AI is working
            if isAnalyzing {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.5)
                    Text("Detecting ingredients...")
                        .foregroundColor(.white)
                        .font(.subheadline)
                }
            }
            
            // The + button
            VStack {
                Spacer()
                Button {
                    capturedImage = nil   // clear old image
                    hasAnalyzed = false   // reset the guard
                    showCamera = true
                } label: {
                    ZStack {
                        Circle()
                            .foregroundColor(.pink)
                            .frame(width: 60, height: 60)
                            .shadow(color: .pink.opacity(0.4), radius: 8, y: 4)
                        
                        Image(systemName: "plus")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                }
                .disabled(isAnalyzing) // disable while loading
                .padding(.bottom, 24)
            }
        }
        
        // Present native camera
        .sheet(isPresented: $showCamera) {
            CameraPicker(selectedImage: $capturedImage, isPresented: $showCamera)
                .ignoresSafeArea()
        }
        
        // When a photo is captured, automatically trigger AI analysis
        .onChange(of: capturedImage) { _, newImage in
            guard let image = newImage, !hasAnalyzed else { return }
            hasAnalyzed = true  // block any repeat calls
            analyzeImage(image)
        }
        
        // When ingredients are ready, show review screen
        .sheet(isPresented: $showIngredientReview) {
            IngredientReviewView(
                vm: IngredientsReviewVM(detectedNames: detectedIngredients)
            )
        }
        
        // Show error if something goes wrong
        .alert("Something went wrong", isPresented: .constant(errorMessage != nil)) {
            Button("OK") { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }
    
    // Calls Gemini and handles the response
    private func analyzeImage(_ image: UIImage) {
        print("🚨 analyzeImage called")
        isAnalyzing = true
        
        Task {
            do {
                let ingredients = try await Service.shared.extractIngredients(from: image)
                
                await MainActor.run {
                    detectedIngredients = ingredients
                    isAnalyzing = false
                    showIngredientReview = true  // go to review screen
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isAnalyzing = false
                }
            }
        }
    }
}
