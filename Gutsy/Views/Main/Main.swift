import SwiftUI
import SwiftData

struct Main: View {
    @Query(sort: \MealLog.date, order: .reverse) private var allMealLogs: [MealLog]
    @StateObject private var statsVM = WeeklyStatsVM()
    @Environment(\.modelContext) private var modelContext
    @State private var newGroups: Set<SuperSixGroups> = []
    @State private var showDiversityPopup = false
    @State private var showInfo = false

    var body: some View {
        NavigationStack() {
            ZStack {
                ScrollView {
                    VStack(spacing: 16) {
                        header
                        statsCards
                        HistorySection(meals: allMealLogs)
                        MicrobiomeOverview(statsVM: statsVM, showInfo: $showInfo)
                        Spacer(minLength: 80)
                    }
                    .padding(.horizontal, 16)
                }
                .background(.bg)
                .navigationBarHidden(true)
                .overlay(alignment: .bottom) {
                    CameraButton { groups in
                        newGroups = groups
                        showDiversityPopup = !groups.isEmpty //only after new diversity
                    }
                }
                
                //full screen dismiss catcher for info button
                if showInfo {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture { withAnimation { showInfo = false } }
                        .ignoresSafeArea()
                }
                
                // Celebration popup
                if showDiversityPopup {
                    DiversityPopup(newGroups: newGroups) { showDiversityPopup = false }
                }
            }
            .onChange(of: allMealLogs) { _, newLogs in statsVM.allMealLogs = newLogs
            }
            
            .onAppear {
                statsVM.allMealLogs = allMealLogs
            }
        }
    }
    
    private var header: some View {
        HStack {
            
            Image("gutsy_logo")
                .resizable()
                .scaledToFit()
                .frame(height: 28)
            Spacer()
            //            Button {
            //                // subscription
            //            } label: {
            //                Image(systemName: "crown")
            //                    .foregroundColor(.yellow)
            //                    .padding(10)
            //                    .background(Color(.systemBackground))
            //                    .clipShape(Circle())
            //            }
        }
//        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
        
    private var statsCards: some View {
        HStack(spacing: 12) {
            PlantsPerWeekCard(plantCount: statsVM.plantsPerWeekCount)
            OverallDiversityCard(percentage: statsVM.diversityPercentage)
        }
    }
}

#Preview {
    Main()
}
