import SwiftUI

struct Main: View {
    @ObservedObject var viewModel = WeeklyStatsVM()
    var body: some View {
        
        VStack(spacing: 10){
            // title + subscription + settings (in toolbar)
            HStack{
                // plants per week card
                Text("\(viewModel.plantCount)/30")
                Spacer()
                
                // overall diversity card
                VStack{
                    Text("\(Int(viewModel.diversityPercentage.rounded()))%")
                    Text(viewModel.diversityLabel)
                }
            }
            // history
            
            // microbiome overview
            // 6x plant_group stats cards
            
            // camera button overlay
            Spacer()
            CameraButton()
        }
        .padding(16)
        
    }
}

#Preview {
    Main()
}
