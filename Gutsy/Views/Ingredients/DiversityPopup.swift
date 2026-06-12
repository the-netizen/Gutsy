import SwiftUI

struct DiversityPopup: View {
    let newGroups: Set<SuperSixGroups>
    let onDone: () -> Void

    private var groups: [SuperSixGroups] {
        SuperSixGroups.allCases.filter { newGroups.contains($0) }
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.25)
                .ignoresSafeArea()
                .onTapGesture { onDone() }

            VStack(spacing: 20) {
                BacteriaContainer(groups: groups)

                Text("diversity increased!")
                    .font(.system(.title2, weight: .bold))

                Button(action: onDone) {
                    Text("Done")
                        .font(.body).fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(width: 120)
                        .padding(.vertical, 15)
                        .background(Color.accentColor)
                        .clipShape(Capsule())
                }
            }
            .padding(15)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .shadow(radius: 20)
            .padding(.horizontal, 40)
        }
        .transition(.opacity)
    }
}

private struct BacteriaContainer: View {
    let groups: [SuperSixGroups]

    // Always the same size
    private let width: CGFloat = 260
    private let height: CGFloat = 200
    private let imageSize: CGFloat = 70

    // Home positions per count (absolute coords within width×height)
    private func homePositions(count: Int) -> [(x: CGFloat, y: CGFloat)] {
        switch count {
        case 1:  return [(130, 100)]
        case 2:  return [(80, 100), (180, 100)]
        case 3:  return [(80, 75), (180, 75), (130, 145)]
        case 4:  return [(75, 70), (185, 70), (75, 145), (185, 145)]
        case 5:  return [(70, 60), (190, 60), (130, 105), (80, 155), (180, 155)]
        default: return [(70, 55), (190, 55), (55, 115), (205, 115), (80, 168), (180, 168)]
        }
    }

    var body: some View {
        let positions = homePositions(count: groups.count)

        ZStack {
            // Faint pink gradient — matches the reference mockup
            LinearGradient(
                colors: [
                    Color.pink.opacity(0.22),
                    Color.pink.opacity(0.04)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            ForEach(Array(groups.enumerated()), id: \.element) { index, group in
                if index < positions.count {
                    FloatingBacterium(
                        imageName: group.bacteriaImage,
                        homeX: positions[index].x,
                        homeY: positions[index].y,
                        size: imageSize,
                        index: index
                    )
                }
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

// MARK: - Individual floating bacterium

private struct FloatingBacterium: View {
    let imageName: String
    let homeX: CGFloat
    let homeY: CGFloat
    let size: CGFloat
    let index: Int

    @State private var floating = false

    // Each bacterium gets a unique drift direction and speed
    private var driftX: CGFloat {
        let xs: [CGFloat] = [7, -8, 6, -7, 8, -6]
        return xs[index % xs.count]
    }
    private var driftY: CGFloat {
        let ys: [CGFloat] = [-8, 7, -7, 8, -6, 7]
        return ys[index % ys.count]
    }
    private var duration: Double { 1.3 + Double(index) * 0.28 }

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .position(
                x: homeX + (floating ? driftX : 0),
                y: homeY + (floating ? driftY : 0)
            )
            .animation(
                .easeInOut(duration: duration)
                    .repeatForever(autoreverses: true)
                    .delay(Double(index) * 0.2),
                value: floating
            )
            .onAppear { floating = true }
    }
}

// MARK: - Previews

#Preview("One group") {
    ZStack {
        Color(.systemGray6).ignoresSafeArea()
        DiversityPopup(newGroups: [.fruits], onDone: {})
    }
}

#Preview("Some groups") {
    ZStack {
        Color(.systemGray6).ignoresSafeArea()
        DiversityPopup(newGroups: [.fruits, .legumes, .herbsAndSpices], onDone: {})
    }
}

#Preview("All groups") {
    ZStack {
        Color(.systemGray6).ignoresSafeArea()
        DiversityPopup(newGroups: Set(SuperSixGroups.allCases), onDone: {})
    }
}
