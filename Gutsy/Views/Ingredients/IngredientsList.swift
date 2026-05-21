import SwiftUI

struct IngredientsList: View {
    @ObservedObject var vm: IngredientsReviewVM

    var body: some View {
        List {
            ingredientRows
            addSection
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .onTapGesture {
            vm.cancelEdit()
            vm.cancelAdd()
        }
    }

    @ViewBuilder
    private var ingredientRows: some View {
        ForEach(vm.ingredients) { ingredient in
            IngredientCard(
                ingredient: ingredient,
                isEditing: vm.editingIngredientID == ingredient.id,
                draftName: $vm.draftName,
                onEdit: { vm.startEditing(ingredient) },
                onDelete: { vm.delete(ingredient) },
                onSave: { vm.saveEdit() }
            )
            .listRowInsets(EdgeInsets(top: 4, leading: 16,
                                     bottom: 4, trailing: 16))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
    }

    @ViewBuilder
    private var addSection: some View {
        if vm.isAddingNew {
            AddIngredientCard(
                name: $vm.draftName,
                onConfirm: { vm.confirmAdd() }
            )
            .listRowInsets(EdgeInsets(top: 4, leading: 16,
                                     bottom: 4, trailing: 16))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }

        addButton
    }

    private var addButton: some View {
        Button {
            vm.showAddCard()
        } label: {
            HStack {
                Spacer()
                Image(systemName: "plus")
                    .font(.title3)
                    .foregroundColor(.pink)
                Spacer()
            }
            .padding(.vertical, 14)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
        }
        .listRowInsets(EdgeInsets(top: 4, leading: 16,
                                 bottom: 4, trailing: 16))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .buttonStyle(.plain)
    }
}

#Preview {
    IngredientsList(
        vm: IngredientsReviewVM(detectedNames: [
            "tomato", "rice", "onion", "garlic", "cumin"
        ])
    )
}
