//
//  LoadingView.swift
//  ReadingAdventures
//

import SwiftUI

struct LoadingView: View {

    @State private var rotateArc = false
    @State private var rotateBacteria = false
    @State private var pulseText = false

    var body: some View {

        VStack {

            Spacer()

            ZStack {

                // Background Ring
                Circle()
                    .stroke(
                        Color.gray.opacity(0.12),
                        lineWidth: 16
                    )
                    .frame(width: 210, height: 210)

                // Rotating Pink Arc
                Circle()
                    .trim(from: 0.15, to: 0.65)
                    .stroke(
                        Color(
                            red: 0.89,
                            green: 0.60,
                            blue: 0.66
                        ),
                        style: StrokeStyle(
                            lineWidth: 16,
                            lineCap: .round
                        )
                    )
                    .frame(width: 210, height: 210)
                    .rotationEffect(.degrees(rotateArc ? 360 : 0))
                    .animation(
                        .linear(duration: 1.8)
                            .repeatForever(autoreverses: false),
                        value: rotateArc
                    )

                // Rotating Bacteria
                ZStack {

                    OrbitingBacteria(
                        imageName: "bacteria_legumes",
                        radius: 105,
                        angle: -140,
                        size: 85
                    )

                    OrbitingBacteria(
                        imageName: "bacteria_wholegrains",
                        radius: 105,
                        angle: 100,
                        size: 75
                    )

                    OrbitingBacteria(
                        imageName: "bacteria_nuts",
                        radius: 105,
                        angle: 15,
                        size: 80
                    )
                }
                .rotationEffect(.degrees(rotateBacteria ? 360 : 0))
                .animation(
                    .linear(duration: 8)
                        .repeatForever(autoreverses: false),
                    value: rotateBacteria
                )
            }
            .frame(width: 280, height: 280)

            Text("This may take a few seconds...")
                .font(.title3)
                .fontWeight(.medium)
                .opacity(pulseText ? 1 : 0.4)
                .animation(
                    .easeInOut(duration: 1)
                        .repeatForever(autoreverses: true),
                    value: pulseText
                )
                .padding(.top, 10)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .onAppear {
            rotateArc = true
            rotateBacteria = true
            pulseText = true
        }
    }
}

struct OrbitingBacteria: View {

    let imageName: String
    let radius: CGFloat
    let angle: Double
    let size: CGFloat

    @State private var animate = false

    var body: some View {

        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .scaleEffect(animate ? 1.08 : 0.92)
            .offset(
                x: cos(angle * .pi / 180) * radius,
                y: sin(angle * .pi / 180) * radius
            )
            .animation(
                .easeInOut(duration: 0.8)
                    .repeatForever(autoreverses: true),
                value: animate
            )
            .onAppear {
                animate = true
            }
    }
}

#Preview {
    LoadingView()
}
