import SwiftUI
import SwiftData

struct Main: View {
    @Query(sort: \MealLog.date, order: .reverse) private var allMealLogs: [MealLog]
    @StateObject private var statsVM = WeeklyStatsVM()
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase //for notifs
    @State private var newGroups: Set<SuperSixGroups> = []
    @State private var showDiversityPopup = false
    @State private var showInfo = false
    
    //check which groups were logged furthest behind this week for personalized notifs
    private var laggingGroup: SuperSixGroups? {
        SuperSixGroups.allCases.min { statsVM.progress(for: $0) < statsVM.progress(for: $1) }
    }

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
            //            .onChange(of: scenePhase) { _, newPhase in
            //                if newPhase == .background {
            //                    let laggingGroup = SuperSixGroups.allCases.min { statsVM.progress(for: $0) < statsVM.progress(for: $1) }
            //                    NotificationManager.shared.refreshDailyReminder(
            //                        mealLogs: allMealLogs,
            //                        plantsPerWeekCount: statsVM.plantsPerWeekCount,
            //                        currentStreak: statsVM.currentStreak,
            //                        laggingGroup: laggingGroup
            //                    )
            //                }
            //            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .background {
                    NotificationManager.shared.refreshDailyReminder(
                        mealLogs: allMealLogs,
                        plantsPerWeekCount: statsVM.plantsPerWeekCount,
                        currentStreak: statsVM.currentStreak,
                        laggingGroup: laggingGroup
                    )
                }
            }
            .onAppear {
                statsVM.allMealLogs = allMealLogs
            }
            .task {
                // Only ever shows the system dialog once per install — safe to call every launch.
                _ = await NotificationManager.shared.requestPermission()
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
            StreakBadge(streak: statsVM.currentStreak)
            
#if DEBUG
//Button("Test") {
//    NotificationManager.shared.debugFireNow(
//        mealLogs: allMealLogs,
//        plantsPerWeekCount: statsVM.plantsPerWeekCount,
//        currentStreak: statsVM.currentStreak,
//        laggingGroup: laggingGroup
//    )
//}
//.font(.caption2)
//.padding(.horizontal, 8).padding(.vertical, 4)
//.background(Color.black.opacity(0.06))
//.clipShape(Capsule())
#endif
            
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
