import SwiftUI

struct StreakBadge: View {
    let streak: Int

    var body: some View {
        if streak > 0 {
            HStack(spacing: 4) {
                Text("🔥")
                Text("\(streak)").font(.subheadline).bold()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.orange.opacity(0.15))
            .clipShape(Capsule())
        }
    }
}

#Preview {
    HStack { StreakBadge(streak: 5); StreakBadge(streak: 0) }.padding()
}
