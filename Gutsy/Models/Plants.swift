import Foundation
import SwiftUI

struct Plants: Codable {
    let name: String
    let group: String
    let benefit: String
    
    var id: String { name } //identified via unique name
}
extension Plants {
    var groupEnum: SuperSixGroups? { SuperSixGroups(rawValue: group) }
}

enum SuperSixGroups: String, Codable, CaseIterable{
    // names
    case fruits         = "Fruits"
    case vegetables     = "Vegetables"
    case wholegrains    = "Wholegrains"
    case legumes        = "Legumes"
    case nutsAndSeeds   = "Nuts & Seeds"
    case herbsAndSpices = "Herbs & Spices"
    
    //icons
    var bacteriaImage: String {
        switch self {
        case .fruits:        return "bacteria_fruits"
        case .vegetables:    return "bacteria_vegetables"
        case .wholegrains:   return "bacteria_wholegrains"
        case .legumes:       return "bacteria_legumes"
        case .nutsAndSeeds:  return "bacteria_nuts"
        case .herbsAndSpices: return "bacteria_herbs"
        }
    }
    
    //colors
    var color: Color {
        switch self {
        case .fruits:         return .colorFruits
        case .vegetables:     return .colorVegetables
        case .wholegrains:    return .colorWholegrains
        case .legumes:        return .colorLegumes
        case .nutsAndSeeds:   return .colorNuts
        case .herbsAndSpices: return .colorHerbs
        }
    }
    var description: String {
        switch self {
        case .fruits:
            return """
            Fruits are the sweet or savory produce of flowering plants, typically containing seeds. They can be eaten fresh, dried, or cooked and are used in a wide range of dishes and snacks.
            Examples: Apple, Mango, Pomegranate
            """
        case .vegetables:
            return """
            Vegetables are edible parts of plants that are commonly eaten as part of meals. They can include roots, leaves, stems, flowers, and other plant parts, and they are often used in salads, soups, and cooked dishes.
            Examples: Carrot, Spinach, Broccoli
            """
        case .wholegrains:
            return """
            Wholegrains are grains that contain all parts of the grain kernel the bran, germ, and endosperm. They are commonly used in foods such as bread, rice, pasta, and cereals.
            Examples: Brown Rice, Oat, Whole Wheat
            """
        case .legumes:
            return """
            Legumes are edible seeds from plants that grow inside pods. They are often used in soups, salads, and main dishes.
            Examples: Lentil, Chickpea, Kidney Bean
            """
        case .nutsAndSeeds:
            return """
            Nuts and seeds are nutrient-rich plant foods that are commonly eaten as snacks or added to meals. Nuts are hard-shelled fruits that contain an edible kernel. Seeds are the small reproductive parts of plants that can grow into new plants. They are good sources of healthy fats, protein, vitamins, and minerals. 
            Examples: Almond, Walnut, Chia Seed, Flaxseed
            """
        case .herbsAndSpices:
            return """
            Herbs and spices are natural plant products used to add flavor, aroma, and sometimes color to food. Herbs usually come from the leaves of plants. Spices usually come from other plant parts such as the seeds, bark, roots, or fruits.
            Examples: Mint, Parsley, Cinnamon, Turmeric
            """
        }// description
        
    }//super 6 groups
}
