import Foundation

struct OnboardingPage: Identifiable {
    let id: Int
    let title: String
    let description: String
    let imageName: String       // asset name in xcassets
    let isLastPage: Bool

    static let pages: [OnboardingPage] = [
        OnboardingPage(
            id: 0,
            title: "Take a Picture!",
            description: "Snap photos of your daily meals to track your plant intake effortlessly.",
            imageName: "onboarding1",
            isLastPage: false
        ),
        OnboardingPage(
            id: 1,
            title: "Know your ingredients",
            description: "We'll detect your ingredients, then you can review, edit, delete, or confirm them.",
            imageName: "onboarding2",
            isLastPage: false
        ),
        OnboardingPage(
            id: 2,
            title: "Track your Gut Health",
            description: "Track your overall diversity, weekly plant count, and each plant group's impact on your gut health.",
            imageName: "onboarding3",
            isLastPage: false
        ),
        OnboardingPage(
            id: 3,
            title: "Start your journey now!",
            description: "Snap your first plate to begin.",
            imageName: "",          // no image on last page
            isLastPage: true
        )
    ]
}
