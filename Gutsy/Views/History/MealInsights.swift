//
//  MealInsights.swift
//  Gutsy
//
//  Created by Naima Khan on 02/06/2026.
//

import SwiftUI

struct MealInsights: View {
    let meal: MealLog

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    let mock = MealLog(
        date: Date(),
        imagePath: nil,
        confirmedPlants: [],
        tag: "Healthy Meal"
    )
    MealInsights(meal: mock )
}
