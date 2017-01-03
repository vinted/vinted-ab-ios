import Foundation

public protocol VNTModel {
    init?(dictionary: [String : Any])
}

public final class VNTABTestVariant: VNTModel {
    public let name: String?
    public let chanceWeight: Int
    
    public required init?(dictionary: [String : Any]) {
        self.name = dictionary["name"] as? String
        if let chanceWeight = dictionary["chance_weight"] as? Int {
            self.chanceWeight = chanceWeight
        } else {
            self.chanceWeight = 0
            return nil
        }
    }
}
