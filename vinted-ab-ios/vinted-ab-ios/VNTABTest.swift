import Foundation
import Unbox

public final class VNTABTest: Unboxable {
    public let identifier: String
    public let name: String
    public let startAt: Date?
    public let endAt: Date?
    public let seed: String
    public let buckets: [Int]?
    public let allBuckets: Bool
    public let variants: [VNTABTestVariant]
    
    public var isRunning: Bool {
        let date = Date()
        let afterStartDate = startAt == nil || date.compare(startAt!) == .orderedDescending
        let beforeEndDate = endAt == nil || date.compare(endAt!) == .orderedAscending
        return afterStartDate && beforeEndDate
    }
    
    public required init(unboxer: Unboxer) throws {
        self.identifier = try unboxer.unbox(key: "id")
        self.name = try unboxer.unbox(key: "name")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        self.startAt = unboxer.unbox(key: "start_at", formatter: dateFormatter)
        self.endAt = unboxer.unbox(key: "end_at", formatter: dateFormatter)
        self.seed = try unboxer.unbox(key: "seed")
        self.buckets = unboxer.unbox(key: "buckets")
        self.allBuckets = (try? unboxer.unbox(key: "all_buckets")) ?? false
        self.variants = try unboxer.unbox(key: "variants")
    }
}
