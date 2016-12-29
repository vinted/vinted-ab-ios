import Foundation
import Unbox

public final class VNTABTestVariant: Unboxable {
    public let name: String
    public let chanceWeight: Int
    
    public required init(unboxer: Unboxer) throws {
        self.name = try unboxer.unbox(key: "name")
        self.chanceWeight = try unboxer.unbox(key: "chance_weight")
    }
}
