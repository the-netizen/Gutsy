import SwiftUI

struct Main: View {
    @ObservedObject var viewModel = WeeklyStatsVM()
    var body: some View {
        ZStack{
            ScrollView{
                // title + subscription + settings (in toolbar)
                HStack {
                    Image("gutsy_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 28)
                    Spacer()
                    Button {
                        // subscription
                    } label: {
                        Image(systemName: "crown")
                            .foregroundColor(.yellow)
                            .padding(10)
                            .background(Color(.systemBackground))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                
                //Stats cards
                //            HStack{
                HStack {
                    PlantsPerWeekCard(plantCount: viewModel.plantsPerWeekCount)
                    
                    OverallDiversityCard(percentage: viewModel.diversityPercentage)
                }
                .padding(.horizontal, 16)
                .padding(.vertical,10)
                
                //            }
                // history
                HistorySection(meals: viewModel.allMealLogs.sorted { $0.date > $1.date }) {
                    
                } onMealTapped: { MealLog in
                    // sheet popup
                }
                .padding(.horizontal, 16)
                
                // microbiome overview
                // 6x plant_group stats cards
                
                // camera button overlay
                Spacer()
            }//vscroll
            .padding(16)
            .background(Color.bg)
            
            CameraButton()
        }//z
    }
}

#Preview {
    Main()
}
