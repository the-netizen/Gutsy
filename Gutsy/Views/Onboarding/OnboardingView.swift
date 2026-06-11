import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0

    let pages = OnboardingPage.pages

    var body: some View {
        ZStack(alignment: .bottom) {

            // Swipeable pages
            TabView(selection: $currentPage) {
                ForEach(pages) { page in
                    OnboardingPageView(page: page){
                        hasCompletedOnboarding = true   // onboarding done
                    }
                        .tag(page.id)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentPage)

            // Dot indicators
            dotsIndicator
                .padding(.bottom, 30)
        }
        .ignoresSafeArea()
        .background(Color.bg)
    }

    private var dotsIndicator: some View {
        HStack(spacing: 8) {
            ForEach(pages) { page in
                Circle()
                    .fill(currentPage == page.id ? Color.accentColor : Color.gray.opacity(0.4))
                    .frame(
                        width: currentPage == page.id ? 10 : 7,
                        height: currentPage == page.id ? 10 : 7
                    )
                    .animation(.easeInOut, value: currentPage)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
