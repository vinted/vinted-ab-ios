import Nimble
import Quick
@testable import vinted_ab_ios

fileprivate enum ModelType: String {
    case full
    case required
}

class VNTABTestTests: QuickSpec {
    
    override func spec() {
        let bundle = Bundle(for: type(of: self))
        
        describe("Initialization") {
            it("initializes model") {
                let object = VNTABTest.mappedObject(bundle: bundle, index: ModelType.full.rawValue)
                expect(object).toNot(beNil())
            }
            
            it("sets required properties") {
                guard let object = VNTABTest.mappedObject(bundle: bundle, index: ModelType.required.rawValue) else {
                    fail()
                    return
                }
                guard let dict = jsonFileDictionary(forType: VNTABTest.self, bundle: bundle, index: ModelType.required.rawValue) else {
                    fail()
                    return
                }

                guard
                    let dictIdentifier = dict["id"] as? Int,
                    let dictName = dict["name"] as? String,
                    let dictSeed = dict["seed"] as? String
                    else {
                        fail()
                        return
                }
                expect(object.identifier).to(equal(String(dictIdentifier)))
                expect(object.name).to(equal(dictName))
                expect(object.seed).to(equal(dictSeed))
                expect(object.variants).toNot(beNil())
                expect(object.startAt).to(beNil())
                expect(object.endAt).to(beNil())
                expect(object.allBuckets).to(beFalsy())
                expect(object.buckets).to(beNil())
            }
            
            it("sets optional properties") {
                guard let object = VNTABTest.mappedObject(bundle: bundle, index: ModelType.full.rawValue) else {
                    fail()
                    return
                }
                guard let dict = jsonFileDictionary(forType: VNTABTest.self, bundle: bundle, index: ModelType.full.rawValue) else {
                    fail()
                    return
                }
                
                let dateFormatter = VNTISO8601DateFormatter()
                guard
                    let dictAllBuckets = dict["all_buckets"] as? Bool,
                    let dictBuckets = dict["buckets"] as? [Int],
                    let dictStartAtString = dict["start_at"] as? String,
                    let dictStartAt = dateFormatter.date(from: dictStartAtString),
                    let dictEndAtString = dict["end_at"] as? String,
                    let dictEndAt = dateFormatter.date(from: dictEndAtString)
                    else {
                        fail()
                        return
                }
                
                expect(object.startAt).to(equal(dictStartAt))
                expect(object.endAt).to(equal(dictEndAt))
                expect(object.allBuckets).to(equal(dictAllBuckets))
                expect(object.buckets).to(equal(dictBuckets))
            }
        }
        
        describe("isRunning") {
            context("with both dates missing") {
                it("returns true") {
                    guard let object = VNTABTest.mappedObject(bundle: bundle, index: ModelType.full.rawValue, dictChanges: [(key: "start_at", value: nil), (key: "end_at", value: nil)]) else {
                        fail()
                        return
                    }
                    expect(object.isRunning).to(beTruthy())
                }
            }
            
            context("with start_at missing") {
                it("checks if today is `before` end_at") {
                    guard let object = VNTABTest.mappedObject(bundle: bundle, index: ModelType.full.rawValue, dictChanges: [(key: "start_at", value: nil)]) else {
                        fail()
                        return
                    }
                    let today = Date()
                    expect(object.isRunning).to(equal(today.compare(object.endAt!) == .orderedAscending))
                }
            }
            
            context("with end_at missing") {
                it("checks if today is `after` start_at") {
                    guard let object = VNTABTest.mappedObject(bundle: bundle, index: ModelType.full.rawValue, dictChanges: [(key: "end_at", value: nil)]) else {
                        fail()
                        return
                    }
                    let today = Date()
                    expect(object.isRunning).to(equal(today.compare(object.startAt!) == .orderedDescending))
                }
            }
        }
    }
}
