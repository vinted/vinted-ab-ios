import Foundation

@objc
public protocol VNTModel {
    init?(dictionary: [String : Any])
}

public extension VNTModel {
    public static func unboxIdentifier(from dictionary: [String : Any]) -> String? {
        if let stringValue = dictionary["id"] as? String {
            return stringValue
        } else if let intValue = dictionary["id"] as? Int {
            return String(intValue)
        } else {
            return nil
        }
    }
}
