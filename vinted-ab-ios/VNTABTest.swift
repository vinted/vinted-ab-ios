import Foundation

public final class VNTABTest: NSObject, VNTModel {
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
    
    public required init?(dictionary: [String : Any]) {
        guard
            let identifier = VNTABTest.unboxIdentifier(from: dictionary),
            let name = dictionary["name"] as? String,
            let seed = dictionary["seed"] as? String
            else {
                return nil
        }
        self.identifier = identifier
        self.name = name
        self.seed = seed
        let dateFormatter = VNTISO8601DateFormatter()
        self.startAt = { () -> Date? in
            if let startAtString = dictionary["start_at"] as? String {
                return dateFormatter.date(from: startAtString)
            } else {
                return nil
            }
        }()
        self.endAt = { () -> Date? in
            if let endAtString = dictionary["end_at"] as? String {
                return dateFormatter.date(from: endAtString)
            } else {
                return nil
            }
        }()
        self.buckets = { () -> [Int]? in
            if let array = dictionary["buckets"] as? [Any] {
                var tempArray: [Int] = []
                for element in array {
                    if let value = element as? Int {
                        tempArray.append(value)
                    } else if let stringValue = element as? String, let value = Int(stringValue) {
                        tempArray.append(value)
                    }
                }
                return tempArray
            }
            return nil
        }()
        self.allBuckets = { () -> Bool in
            if let boolValue = dictionary["all_buckets"] as? Bool {
                return boolValue
            } else if let stringValue = dictionary["all_buckets"] as? String {
                return stringValue == "1"
            } else if let intValue = dictionary["all_buckets"] as? Int {
                return intValue == 1
            } else {
                return false
            }
        }()
        self.variants = VNTABTest.unboxVariants(dictionary: dictionary)
    }
    
    private class func unboxVariants(dictionary: [String : Any]) -> [VNTABTestVariant] {
        var tempArray: [VNTABTestVariant] = []
        if let variants: [Any] = dictionary["variants"] as? [Any] {
            for variant in variants {
                if let variantDict = variant as? [String : Any],
                    let unboxedVariant = VNTABTestVariant(dictionary: variantDict) {
                    tempArray.append(unboxedVariant)
                }
            }
        }
        return tempArray
    }
}
