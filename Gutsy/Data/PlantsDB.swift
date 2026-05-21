import Foundation

class PlantDB {
    static let shared = PlantDB()
    private var plants: [String: Plants] = [:]

    private init() { load() }

    private func load() {
        guard let url = Bundle.main.url(forResource: "plants", withExtension: "json"),
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
    
}
