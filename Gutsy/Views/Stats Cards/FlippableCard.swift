import SwiftUI

struct FlippableCard<Front: View, Back: View>: View {
    let front: Front
    let back: Back

    @State private var rotation = 0.0

    // True when card is rotated past 90°
    private var showingBack: Bool {
        let normalized = rotation.truncatingRemainder(dividingBy: 360)
        let absolute = abs(normalized)
        return absolute > 90 && absolute < 270
    }

    init(@ViewBuilder front: () -> Front,
         @ViewBuilder back: () -> Back) {
        self.front = front()
        self.back = back()
    }

    var body: some View {
        ZStack {
            // Front face
            cardFace(content: front)
                .opacity(showingBack ? 0 : 1)

            // Back face — pre-rotated so text reads correctly when flipped
            cardFace(content: back)
                .opacity(showingBack ? 1 : 0)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        }
        .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
        .onTapGesture { flip() }
    }

    private func cardFace<C: View>(content: C) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content

            Image(systemName: "arrow.clockwise")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.component)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
    }

    // MARK: - Flip animation

    private func flip() {
        withAnimation(.spring(duration: 0.5)) {
            rotation += 180
        }
    }
}
