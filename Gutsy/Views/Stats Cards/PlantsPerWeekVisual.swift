import SwiftUI

struct PlantsPerWeekVisual: View {
    let progress: Double   // 0.0 to 1.0
    private let totalTicks = 30

    var body: some View {
        ZStack {
            ForEach(0..<totalTicks, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(tickColor(for: index))
                    .frame(width: 3, height: 15)
                    .offset(y: -45)
                    .rotationEffect(.degrees(Double(index) * (360.0 / Double(totalTicks))))
            }
        }
    }

    private func tickColor(for index: Int) -> Color {
        let filledTicks = Int(progress * Double(totalTicks))
        return index < filledTicks ? Color.pink : Color(.systemGray4)
    }
}

#Preview {
    PlantsPerWeekVisual(progress: 0.4)
        .frame(width: 100, height: 100)
}
