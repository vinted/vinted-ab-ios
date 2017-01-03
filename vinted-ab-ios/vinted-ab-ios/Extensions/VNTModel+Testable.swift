import Foundation

private let NumberedJsonFileFormat = "%@[%@]"

public extension VNTModel {
    static func mappedObject(bundle: Bundle, index: String, dictChanges: [(key: String, value: AnyObject?)] = []) -> Self? {
        guard let dict = jsonFileDictionary(forType: self,
                                            bundle: bundle,
                                            index: index) else { return nil }
        
        var updatedDict = dict
        for dictChange in dictChanges {
            updatedDict = updateDictionary(dict: dict as [String : AnyObject], keyPath: dictChange.key, value: dictChange.value)
        }
        return self.init(dictionary: updatedDict)
    }
    
    static func loadSample(_ bundle: Bundle, index: String = "0", replace key: String? = nil, with value: AnyObject? = nil) -> Self? {
        if let key = key {
            return mappedObject(bundle: bundle, index: index, dictChanges: [(key: key, value: value)])
        }
        return mappedObject(bundle: bundle, index: index)
    }
}


private func updateDictionary(dict: [String: AnyObject], keyPath: String, value: AnyObject?) -> [String: AnyObject] {
    var dictToEdit: [String: AnyObject] = dict
    
    let keys = keyPath.characters.split { $0 == "." }.map(String.init)
    for (i, key) in keys.enumerated() {
        if keys.count == 1 {
            dictToEdit[key] = value
        }
        else if let dictToUpdate = dictToEdit[key] as? [String: AnyObject] {
            var subset = keys
            subset.remove(at: i)
            dictToEdit[key] = updateDictionary(dict: dictToUpdate, keyPath: subset.joined(separator: "."), value: value) as AnyObject?
        }
    }
    return dictToEdit
}

public func jsonFileString(forType type: Any, bundle: Bundle, index: String) -> String? {
    guard let data = jsonFileData(forType: type, bundle: bundle, index: index) else { return nil }
    return String(data: data, encoding: String.Encoding.utf8)
}

public func jsonFileDictionary(forType type: Any, bundle: Bundle, index: String) -> [String : Any]? {
    guard let data = jsonFileData(forType: type, bundle: bundle, index: index) else { return nil }
    var dict: [String : Any]?
    do {
        dict = try JSONSerialization.jsonObject(with: data,
            options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any]
    } catch {
        return nil
    }
    return dict
}

private func jsonFileData(forType type: Any, bundle: Bundle, index: String) -> Data? {
    guard let filePath = jsonFilePath(forType: type, bundle: bundle, index: index) else {
        return nil
    }
    return (try? Data(contentsOf: URL(fileURLWithPath: filePath)))
}

private func jsonFilePath(forType type: Any, bundle: Bundle, index: String) -> String? {
    guard let resourceName = jsonFileName(forType: type, index: index) else { return nil }
    return bundle.path(forResource: resourceName, ofType: "json")
}

private func jsonFileName(forType type: Any, index: String) -> String? {
    guard let lastComponent = "\(String(describing: type))".components(separatedBy: ".").first else { return nil }
    return String(format: NumberedJsonFileFormat, lastComponent, index)
}
