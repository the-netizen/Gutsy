import SwiftUI

struct IngredientReviewView: View {
    @StateObject var vm: IngredientsReviewVM
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    let onConfirm: (() -> Void)?   // optional so old call sites don't break

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                Text("Confirm, edit or delete any ingredient.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
                    .padding(.bottom, 30)
                
                IngredientsList(vm: vm)
                
                confirmButton
                
                
            } //vstack
            .background(Color(.systemGray6))
            .navigationTitle("Ingredients")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }// body
    
    private var confirmButton: some View {
            Button {
                vm.save(using: modelContext)
                if let onConfirm {
                    onConfirm()   // called from Main flow — pops back
                } else {
                    dismiss()     // called standalone — just dismisses
                }
            } label: {
                Text("Confirm")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.pink)
                    .clipShape(Capsule())
                    .padding(.horizontal, 40)
            }
            .padding(.vertical, 16)
        }
}
#Preview("With ingredients") {
    IngredientReviewView(
        vm: IngredientsReviewVM(detectedNames: [
            "tomato", "rice", "onion", "garlic", "cumin", "parsley"
        ]), onConfirm: {}
    )
}

#Preview("Empty") {
    IngredientReviewView(
        vm: IngredientsReviewVM(detectedNames: []), onConfirm: {}
    )
}
