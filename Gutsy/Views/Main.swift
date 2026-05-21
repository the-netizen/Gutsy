import SwiftUI

struct Main: View {
    var body: some View {
        
        VStack(spacing: 10){
            // title + subscription + settings (in toolbar)
            HStack{
                // plants per week card
                // overall diversity card
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
