import SwiftUI
import SwiftData

struct MealCard: View {
    let meal: MealLog
    let style: MealLog.MealCardStyle
    let onTap: () -> Void

    var body: some View {
        switch style {
        case .compact:  compactCard
        case .gallery:  galleryCard
        }
    }

    /// Compact style on mainView
    private var compactCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            mealImage
                .frame(width: 110, height: 110)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(6)

            Text(meal.shortFormattedDate)
                .font(.callout)
                .foregroundColor(.primary.opacity(0.7))
                .lineLimit(1)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
        }
        .onTapGesture { onTap() }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.12), radius: 5, x: 0, y: 4)
    }

    /// Gallery style in historyView
    private var galleryCard: some View {
        ZStack(alignment: .center) {
            ZStack(alignment: .topLeading) {
                mealImage
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.systemBackground), lineWidth: 3)
                    )
//                    .clipped()

                if let tag = meal.tags.first {
                    TagPill(tag: tag).padding(8)
                }
            }

            Text(meal.formattedTime)
                .font(.title3).bold()
                .foregroundColor(.white)
                .shadow(radius: 2)
                .padding(8)
        }
        .onTapGesture { onTap() }
        .shadow(color: Color.black.opacity(0.12), radius: 6, y: 3)
    }

    // Loads image from file path — shows placeholder if nil
    private var mealImage: some View {
        Group {
            if let filename = meal.imagePath,
               let uiImage = ImageStorage.load(from: filename) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                // Placeholder when no image saved yet
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray5))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.secondary)
                    )
            }
        }
    }

    //temporary tags
    private func tagPill(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(.primary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(.systemBackground).opacity(0.9))
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(Color(.systemGray4), lineWidth: 0.5)
            )
    }
}

#Preview("Compact") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: MealLog.self, Tag.self, configurations: config)

    let tag = Tag(name: "Healthy Meal", colorName: "color_fruits")
    let mock = MealLog(confirmedPlants: [], tags: [tag])
    container.mainContext.insert(mock)

    return HStack(spacing: 5) {
        MealCard(meal: mock, style: .compact, onTap: {})
        MealCard(meal: mock, style: .compact, onTap: {})
        MealCard(meal: mock, style: .compact, onTap: {})
    }
    .modelContainer(container)
}

#Preview("Gallery") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: MealLog.self, Tag.self, configurations: config)

    let tag = Tag(name: "High in Fiber", colorName: "color_legumes")
    let mock = MealLog(confirmedPlants: [], tags: [tag])
    container.mainContext.insert(mock)

    return HStack(spacing: 8) {
        MealCard(meal: mock, style: .gallery, onTap: {})
        MealCard(meal: mock, style: .gallery, onTap: {})
        MealCard(meal: mock, style: .gallery, onTap: {})
    }
//    .padding()
    .modelContainer(container)
}
