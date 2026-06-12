import SwiftUI

struct MealInsightGraph: View {
    let meal: MealLog

    private var bars: [GroupBar] { MealGraphData.bars(for: meal) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Plant Group").font(.headline)
            HStack(alignment: .top, spacing: 16) {
                barColumn
                legend
            }
        }
    }

    private var barColumn: some View {
        GeometryReader { geo in
            let h = geo.size.height
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(bars) { bar in
                    VStack(spacing: 4) {
                        Text(bar.share > 0 ? "\(Int((bar.share * 100).rounded()))%" : "")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        RoundedRectangle(cornerRadius: 8)
                            .fill(bar.group.color)
                            .frame(height: max(4, h * CGFloat(bar.share)))
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .frame(height: 160)
    }

    private var legend: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(bars) { bar in
                HStack(spacing: 6) {
                    Circle().fill(bar.group.color).frame(width: 10, height: 10)
                    Text(bar.group.rawValue).font(.system(size: 11)).foregroundColor(.secondary)
                }
            }
        }
        .fixedSize()
    }
}

#Preview {
    let mock = MealLog(confirmedPlants: [
        Plants(name: "Strawberry", group: "Fruits", benefit: ""),
        Plants(name: "Apple", group: "Fruits", benefit: ""),
        Plants(name: "Banana", group: "Fruits", benefit: ""),
        Plants(name: "Spinach", group: "Vegetables", benefit: ""),
        Plants(name: "Coffee", group: "Herbs & Spices", benefit: "")
    ])
    return MealInsightGraph(meal: mock).padding()
}
