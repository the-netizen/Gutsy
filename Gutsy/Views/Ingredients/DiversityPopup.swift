import SwiftUI

struct DiversityPopup: View {
    let onDone: () -> Void

    var body: some View {
        ZStack {
            // Dimmed background — Main stays visible behind
            Color.black.opacity(0.25)
                .ignoresSafeArea()
                .onTapGesture { onDone() }

            VStack(spacing: 20) {
                // Bacteria illustration
                Image("bacteria_fruits")   // depends on which plant group.
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)

                Text("diversity increased !")
                    .font(.system(size: 22, weight: .bold))

                Button(action: onDone) {
                    Text("Done")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(width: 160)
                        .padding(.vertical, 14)
                        .background(Color.accentColor)
                        .clipShape(Capsule())
                }
            }
            .padding(28)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .shadow(radius: 20)
            .padding(.horizontal, 40)
        }
        .transition(.opacity)
    }
}

#Preview {
    DiversityPopup(onDone: {})
}
