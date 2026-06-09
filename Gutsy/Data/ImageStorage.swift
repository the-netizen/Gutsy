import UIKit

struct ImageStorage {

    static func save(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            print("❌ Could not convert image to data")
            return nil
        }
        let filename = UUID().uuidString + ".jpg"
        let url = documentsURL().appendingPathComponent(filename)
        do {
            try data.write(to: url)
            print("✅ Image saved:", filename)
            return filename            // store ONLY the filename
        } catch {
            print("❌ Image save failed:", error)
            return nil
        }
    }

//    static func load(from filename: String) -> UIImage? {
//        let url = documentsURL().appendingPathComponent(filename)
//        return UIImage(contentsOfFile: url.path)   // rebuild path at read time
//    }

    static func load(from filename: String) -> UIImage? {
        let url = documentsURL().appendingPathComponent(filename)
        let exists = FileManager.default.fileExists(atPath: url.path)
        print("🖼️ load:", filename, "| exists:", exists, "| dir:", url.deletingLastPathComponent().lastPathComponent)
        return UIImage(contentsOfFile: url.path)
    }
    
    // Always resolves to the CURRENT container's Documents dir
    private static func documentsURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
