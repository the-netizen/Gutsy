import SwiftUI

struct Main: View {
    @ObservedObject var viewModel = WeeklyStatsVM()
    var body: some View {
        
        VStack(spacing: 10){
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
            HStack{
                HStack(spacing: 12) {
                    
                    PlantsPerWeekCard(plantCount: viewModel.plantsPerWeekCount)
                    
                    OverallDiversityCard(percentage: viewModel.diversityPercentage)
                }
                .padding(.horizontal, 16)
                                
            }
            // history
            
            // microbiome overview
            // 6x plant_group stats cards
            
            // camera button overlay
            Spacer()
            CameraButton()
        }
        .padding(16)
        .background(Color.bg)
        
    }
}

#Preview {
    Main()
}
