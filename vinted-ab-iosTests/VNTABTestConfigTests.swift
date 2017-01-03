import Nimble
import Quick
@testable import vinted_ab_ios

fileprivate enum ModelType: String {
    case all_buckets
    case already_finished
    case big_weights
    case explicit_times
    case few_buckets
    case has_not_started
    case multiple_tests
    case multiple_variants
    case no_buckets
    case no_end
    case no_variants
    case zero_buckets
    case zero_weight
    
    var input: String { return rawValue + "_input" }
    var output: String { return rawValue + "_output" }
    
    static var allCases: [ModelType] {
        return [.all_buckets, .already_finished, .big_weights, .explicit_times, .few_buckets, .has_not_started, .multiple_tests, .multiple_variants, .no_buckets, .no_end, .no_variants, .zero_buckets, .zero_weight]
    }
}

class VNTABTestConfigTests: QuickSpec {
    
    override func spec() {
        let bundle = Bundle(for: type(of: self))
        
        describe("Initialization") {
            it("initializes model in all cases") {
                for modelCase in ModelType.allCases {
                    let object = VNTABTestConfig.mappedObject(bundle: bundle, index: modelCase.input)
                    expect(object).toNot(beNil())
                }
            }
        }
        
        describe("variants") {
            it("assigns correct test variants to identifiers") {
                for modelCase in ModelType.allCases {
                    guard
                        let testConfig = VNTABTestConfig.mappedObject(bundle: bundle, index: modelCase.input),
                        let results = jsonFileDictionary(forType: VNTABTestConfig.self, bundle: bundle, index: modelCase.output)
                        else {
                            fail()
                            return
                    }
                    let testName = results["test"] as! String
                    let variants = results["variants"] as! [String: [Int]]
                    for variantName in variants.keys {
                        for variantIdentifier in variants[variantName]! {
                            let actualVariant = testConfig.assignedVariant(forTestName: testName, identifier: String(variantIdentifier))
                            
                            if variantName == "" {
                                expect(actualVariant?.name).to(beNil())
                            } else {
                                expect(actualVariant?.name).to(equal(variantName))
                            }
                        }
                    }
                }
            }
        }
    }
}
