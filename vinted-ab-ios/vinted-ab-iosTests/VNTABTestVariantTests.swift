import Nimble
import Quick
@testable import vinted_ab_ios

fileprivate enum ModelType: String {
    case full
    case required
}

class VNTABTestVariantTests: QuickSpec {
    
    override func spec() {
        let bundle = Bundle(for: type(of: self))
        
        describe("Initialization") {
            it("initializes model") {
                let object = VNTABTestVariant.mappedObject(bundle: bundle, index: ModelType.required.rawValue)
                expect(object).toNot(beNil())
            }
            
            it("sets required properties") {
                guard let object = VNTABTestVariant.mappedObject(bundle: bundle, index: ModelType.required.rawValue) else {
                    fail()
                    return
                }
                guard let dict = jsonFileDictionary(forType: VNTABTestVariant.self, bundle: bundle, index: ModelType.required.rawValue) else {
                    fail()
                    return
                }

                guard let dictChanceWeight = dict["chance_weight"] as? Int else {
                        fail()
                        return
                }
                expect(object.chanceWeight).to(equal(dictChanceWeight))
                expect(object.name).to(beNil())
            }
            
            it("sets optional properties") {
                guard let object = VNTABTestVariant.mappedObject(bundle: bundle, index: ModelType.full.rawValue) else {
                    fail()
                    return
                }
                guard let dict = jsonFileDictionary(forType: VNTABTestVariant.self, bundle: bundle, index: ModelType.full.rawValue) else {
                    fail()
                    return
                }
                
                guard let dictName = dict["name"] as? String else {
                    fail()
                    return
                }
                expect(object.name).to(equal(dictName))
            }
        }
    }
}
