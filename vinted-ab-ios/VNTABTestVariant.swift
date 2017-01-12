import Foundation

public final class VNTABTestVariant: NSObject, VNTModel {
    public let name: String?
    public let chanceWeight: Int
    
    public required init?(dictionary: [String : Any]) {
        guard let chanceWeight = dictionary["chance_weight"] as? Int else {
            return nil
        }
        self.name = dictionary["name"] as? String
        self.chanceWeight = chanceWeight
    }
}
