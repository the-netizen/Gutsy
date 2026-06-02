import SwiftUI

struct SplashScreenView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    @State private var isActive = false //switch to main App
    @State private var opacity = 1.0 //for fade out animations

    var body: some View {
        if isActive {
            if hasCompletedOnboarding{
                Main()
            } else {
                OnboardingView()
            }
        } else {
            splashContent
                .onAppear {
                    // Wait 2.5 seconds then fade out
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation(.easeOut(duration: 0.5)) {
                            opacity = 0.0
                        }
                        // Switch to main after fade completes
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isActive = true
                        }
                    }
                }
                .opacity(opacity)
        }
    }

    private var splashContent: some View {
        ZStack {
            Color(.bg)
                .ignoresSafeArea()

            VStack{
                VStack {
                    Text("Welcome to")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.black)

                    Image("gutsy_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)

                    Text("Healthier Gut, One Plant at a Time.")
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.gray)
                        .padding(.top, 50)
                }
//                .padding(.top, 80)
                .padding(.top, UIScreen.main.bounds.height * 0.24) // 24% from top
                .padding(.horizontal, 16)

                Spacer()

                Image("splash_illustration")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .offset(y: 10) //drag it down to fill gap
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
