import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingPage
    var onFinish: () -> Void = {} //
    
    var body: some View {
        if !page.isLastPage{
            regularPages
        } else{
            lastPage
        }
    }
    
    private var regularPages: some View{
        VStack(spacing: 0) {

            Spacer()
            
            // Title
            Text(page.title)
                .foregroundColor(.black) //change hardcoding later
                .font(.title)
                .bold()
                .padding(.horizontal, 30)
                .padding(.bottom, 50)


            // Image
            if !page.imageName.isEmpty {
                Image(page.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 280)
                    .padding(.horizontal, 40)
            }

            Spacer()

            // Description
            Text(page.description)
                .font(.title3)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer(minLength: 170)
        }
    }//regular pages layout
    
    private var lastPage: some View{
        VStack(spacing: 8) {
            HStack{
                Spacer()
                Button("Skip") {
                    onFinish()
                }
                .font(.system(.subheadline, weight: .medium))
                .foregroundColor(.secondary)
                .padding(30)
            }
            Spacer()
            
            Text(page.title)
                .foregroundColor(.black) //change hardcoding later
                .font(.title)
                .bold()
                .padding(.horizontal, 30)
            
            Text(page.description)
                .foregroundColor(.gray)
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            
            Spacer()

            CameraButton { _ in onFinish() }   //ignore the groups, just signal done
                .frame(height: 100)
            
            // Space reserved for the dot indicators below
            Spacer().frame(height: 50)
        }
    }//last page
}

#Preview("Page 1") {
    OnboardingPageView(page: OnboardingPage.pages[2])
}

#Preview("Page 4 - Last") {
    OnboardingPageView(page: OnboardingPage.pages[3])
}
