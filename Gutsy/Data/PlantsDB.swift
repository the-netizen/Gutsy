import Foundation

class PlantDB {
    static let shared = PlantDB()
    private var plants: [String: Plants] = [:]

    private init() { load() }

    private func load() {
        guard let url = Bundle.main.url(forResource: "Plants", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let entries = try? JSONDecoder().decode([Plants].self, from: data) else {
            print("❌ Could not load plants.json")
            return
        }
        for entry in entries {
            plants[entry.name.lowercased()] = entry
        }
        print("✅ Loaded \(plants.count) plants")
    }

    func lookup(_ name: String) -> Plants? {
        plants[name.lowercased()]
    }

    func filterPlants(from names: [String]) -> [Plants] {
        names.compactMap { lookup($0) }
    }
    
    func allPlantNames() -> String {
        return plants.keys.sorted().joined(separator: ", ")
    }
    // for drop down
    func suggestions(matching query: String, limit: Int = 6) -> [String] {
        let q = query.trimmingCharacters(in: .whitespaces).lowercased()
        guard !q.isEmpty else { return [] }

        let allNames = plants.keys.sorted()
        // Prefix matches first ("a" → Apple, Almond…), then looser contains matches.
        let prefix   = allNames.filter { $0.hasPrefix(q) && $0 != q }
        let contains = allNames.filter { $0.contains(q) && !$0.hasPrefix(q) }
        return (prefix + contains).prefix(limit).map { $0.capitalized }
    }
}
