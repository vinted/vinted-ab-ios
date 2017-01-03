import Foundation
import Unbox
import CCommonCrypto
import BigInt

public final class VNTABTestConfig: Unboxable {
    public let salt: String
    public let bucketCount: Int
    public let abTests: [VNTABTest]
    
    public required init(unboxer: Unboxer) throws {
        self.salt = try unboxer.unbox(key: "salt")
        self.bucketCount = (try? unboxer.unbox(key: "bucket_count")) ?? 0
        self.abTests = { () -> [VNTABTest] in
            if let array = unboxer.dictionary["ab_tests"] as? [Any] {
                var retArray: [VNTABTest] = []
                for element in array {
                    if let dictionary = element as? [String : Any],
                       let unboxedValue = VNTABTest(dictionary: dictionary) {
                        retArray.append(unboxedValue)
                    }
                }
                return retArray
            } else {
                return []
            }
        }()
    }
    
    public func assignedVariant(forTestName name:String, identifier:String) -> VNTABTestVariant? {
        guard let test = abtest(forName: name) else {
            return nil
        }
        return assignedVariant(forTest: test, identifier: identifier)
    }
    
    // MARK: - Private
    
    private func bucketIdentifier(forIdentifier: String) -> Int? {
        guard
            let digestedString = hexDigestedString(fromString: salt.appending(forIdentifier)),
            let bigInteger = BigInt(digestedString, radix: 16)
            else {
                return nil
        }
        
        let bucketCount = BigInt(self.bucketCount)
        let remainder = bigInteger % bucketCount
        return Int(truncatingBitPattern: remainder.toIntMax())
    }
    
    private func hexDigestedString(fromString: String) -> String? {
        let shaData = sha256(fromString: fromString)
        return shaData?.map { String(format: "%02hhx", $0) }.joined()
    }
    
    private func sha256(fromString: String) -> Data? {
        guard var stringData = fromString.data(using: String.Encoding.utf8) else { return nil }
        var digestedData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = digestedData.withUnsafeMutableBytes { dataDigestBytes in
            stringData.withUnsafeMutableBytes { stringDigestBytes in
                CC_SHA256(stringDigestBytes, CC_LONG(stringData.count), dataDigestBytes)
            }
        }
        return digestedData
    }
    
    private func testInBucket(test: VNTABTest, identifier: String) -> Bool {
        guard let bucketIdentifier = self.bucketIdentifier(forIdentifier: identifier) else {
            return false
        }
        return test.allBuckets || test.buckets?.contains(bucketIdentifier) == true
    }
    
    private func abtest(forName: String) -> VNTABTest? {
        return abTests.filter { test in
            test.name == forName
        }.first
    }
    
    private func assignedVariant(forTest test: VNTABTest, identifier: String) -> VNTABTestVariant? {
        guard test.isRunning && testInBucket(test: test, identifier: identifier) else {
            return nil
        }
        guard
            let weightIdentifier = self.weightIdentifier(forTest: test, identifier: identifier)
            else {
            return nil
        }
        var sum = 0
        for variant in test.variants {
            sum += variant.chanceWeight
            if sum > weightIdentifier {
                return variant
            }
        }
        return nil
    }
    
    private func weightIdentifier(forTest test: VNTABTest, identifier: String) -> Int? {
        guard
            let digestedString = hexDigestedString(fromString: test.seed.appending(identifier)),
            let bigInteger = BigInt(digestedString, radix: 16)
            else {
                return nil
        }
        let variantWeightSum = self.variantWeightSum(ofTest: test)
        let variantWeightSumBigInteger = BigInt(variantWeightSum > 0 ? variantWeightSum : 1)
        let remainder = bigInteger % variantWeightSumBigInteger
        return Int(truncatingBitPattern: remainder.toIntMax())
    }
    
    private func variantWeightSum(ofTest: VNTABTest) -> Int {
        return ofTest.variants.reduce(0, { sum, variant in
            sum + variant.chanceWeight
        })
    }
}
