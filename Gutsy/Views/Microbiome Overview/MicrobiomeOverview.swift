import SwiftUI

struct MicrobiomeOverview: View {
    @ObservedObject var statsVM: WeeklyStatsVM

    @State private var expandedGroup: SuperSixGroups? = nil
    @State private var showInfo = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
                .padding(16)

            ForEach(SuperSixGroups.allCases, id: \.self) { group in
                MicrobiomeGroupRow(
                    group: group,
                    count: statsVM.count(for: group),
                    progress: statsVM.progress(for: group),
                    eatenPlants: statsVM.plantsEaten(for: group),
                    isExpanded: expandedGroup == group,
                    onToggle: {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            expandedGroup = (expandedGroup == group) ? nil : group
                        }
                    }
                )
            }
        }
//        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        // Info popup
        .overlay(alignment: .top) {
            if showInfo {
                infoPopup
                    .padding(.top, 40)
                    .transition(.opacity.combined(with: .scale))
            }
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Microbiome Overview")
                    .font(.system(size: 20, weight: .bold))
                Text("Plants Groups")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button {
                withAnimation { showInfo.toggle() }
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.secondary)
                    .font(.title3)
            }
        }
    }

    private var infoPopup: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Microbiome Overview")
                .font(.headline)
            Text("Refers to the community of microorganisms living in the human body, especially the gut. It helps with digestion, immunity, and overall health.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.15), radius: 10, y: 4)
        .padding(.horizontal, 40)
        .onTapGesture { withAnimation { showInfo = false } }
    }
}

#Preview{
    MicrobiomeOverview(statsVM: WeeklyStatsVM())
}
