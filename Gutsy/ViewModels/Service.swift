import UIKit

class Service {
    static let shared = Service()
    
    private let apiKey: String = {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
              let dict = NSDictionary(contentsOf: url),
              let key = dict["GeminiAPIKey"] as? String, !key.isEmpty else {
            fatalError("Missing GeminiAPIKey in Secrets.plist")
        }
        return key
    }()
    private let url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"
    func extractIngredients(from image: UIImage) async throws -> [String] {
        
        // 1. Convert image to base64
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            throw GeminiError.imageConversionFailed
        }
        let base64String = imageData.base64EncodedString()
        
        //get plant names from database
//        let plantList = PlantDB.shared.allPlantNames()
            
        // 2. Build the request body
        let body: [String: Any] = [
            "contents": [[
                "parts": [
                    [
                        "inline_data": [
                            "mime_type": "image/jpeg",
                            "data": base64String
                        ]
                    ],
                    [
                        "text": """
                        You are a plant ingredient detector for a gut health app based on the "30 plants per week" research.
                        
                        Analyze this meal photo and identify ALL plant-based ingredients visible.
                        
                        The 6 plant groups that COUNT are:
                        1. Vegetables — tomato, onion, garlic, spinach, lettuce, carrot, pepper, broccoli, etc.
                        2. Fruits — apple, banana, dates, berries, lemon, avocado, olives, etc.
                        3. Wholegrains — rice, oats, wheat, bread, pasta, quinoa, barley, corn, etc.
                        4. Legumes — lentils, chickpeas, beans, peas, hummus, etc.
                        5. Nuts & Seeds — almonds, walnuts, sesame, sunflower seeds, tahini, etc.
                        6. Herbs & Spices — coffee, tea, cinnamon, turmeric, cumin, parsley, mint, black pepper, cardamom, ginger, saffron, thyme, etc.
                        
                        Important rules:
                        - Coffee and tea ALWAYS count as Herbs & Spices
                        - Ignore meat, chicken, fish, dairy, eggs, and cooking oils
                        - If an ingredient belongs to any of the 6 groups above, include it
                        - Be generous — if you can reasonably identify a plant ingredient, include it
                        
                        Return ONLY a valid JSON array of ingredient names in lowercase English.
                        Example: ["tomato", "rice", "onion", "coffee", "cinnamon"]
                        If no plants are visible, return: []
                        Return nothing else. No explanation. No markdown. Just the raw JSON array.
                        """
                    ]
                ]
            ]]
        ]
        
        // 3. Make the network request
        guard let requestURL = URL(string: "\(url)?key=\(apiKey)") else {
            throw GeminiError.invalidURL
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Debug — see exactly what Gemini returns
        print("🔍 Gemini raw response:", String(data: data, encoding: .utf8) ?? "nil")
        
        return try parseIngredients(from: data)
    }
    
    private func parseIngredients(from data: Data) throws -> [String] {
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            print("❌ Could not parse top-level JSON")
            throw GeminiError.invalidResponse
        }
        
        // Check for API-level errors
        if let error = json["error"] as? [String: Any],
           let message = error["message"] as? String {
            print("❌ Gemini API error:", message)
            throw GeminiError.invalidResponse
        }
        
        guard let candidates = json["candidates"] as? [[String: Any]],
              let first = candidates.first,
              let content = first["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]],
              let text = parts.first?["text"] as? String else {
            print("❌ Unexpected structure:", json)
            throw GeminiError.invalidResponse
        }
        
        print("✅ Gemini text:", text)
        
        // Clean up any markdown formatting Gemini might add
        let cleaned = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let arrayData = cleaned.data(using: .utf8),
              let ingredients = try? JSONSerialization.jsonObject(with: arrayData) as? [String] else {
            print("❌ Parse failed on:", cleaned)
            throw GeminiError.parsingFailed
        }
        
        return ingredients
    }
    func generateInsight(for plantNames: [String]) async throws -> String {
        guard !plantNames.isEmpty else { return "No plants detected in this meal." }

        let body: [String: Any] = [
            "contents": [[
                "parts": [[
                    "text": """
                    You are a friendly gut-health assistant for an app based on the "30 plants per week" concept.
                    A meal contained these plant ingredients: \(plantNames.joined(separator: ", ")).
                    Write ONE encouraging sentence (max 25 words) about how this meal supports gut health and microbiome diversity.
                    Plain text only. No markdown, no quotes, no preamble.
                    """
                ]]
            ]]
        ]

        guard let requestURL = URL(string: "\(url)?key=\(apiKey)") else { throw GeminiError.invalidURL }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        print("🔍 Insight raw response:", String(data: data, encoding: .utf8) ?? "nil")

        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw GeminiError.invalidResponse
        }
        if let error = json["error"] as? [String: Any],
           let message = error["message"] as? String {
            print("❌ Gemini API error (insight):", message)
            throw GeminiError.invalidResponse
        }
        guard let candidates = json["candidates"] as? [[String: Any]],
              let content = candidates.first?["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]],
              let text = parts.first?["text"] as? String else {
            throw GeminiError.invalidResponse
        }
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

enum GeminiError: LocalizedError {
    case imageConversionFailed
    case invalidURL
    case invalidResponse
    case parsingFailed
    
    var errorDescription: String? {
        switch self {
        case .imageConversionFailed: return "Could not process the image"
        case .invalidURL:            return "Invalid API URL"
        case .invalidResponse:       return "Unexpected response from AI"
        case .parsingFailed:         return "Could not read ingredient list"
        }
    }
}
