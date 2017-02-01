typealias JSONDict = Dictionary<String, AnyObject>
typealias JSONArray = Array<JSONDict>

protocol ModelList {
    init(JSONList: JSONArray)
}

protocol ModelObject {
    init(JSONDictionary: JSONDict)
}

extension Array where Element: ExpressibleByDictionaryLiteral
{
    func JSONModelObjectListOfType<U: ModelObject>(modelObjectType: U.Type) -> [U] {
        var returnArray = [U]()
        
        for currentDict in self {
            if let currentJSONDict = currentDict as? JSONDict {
                returnArray.append(U.self.init(JSONDictionary: currentJSONDict))
            }
        }
        
        return returnArray
    }
}

extension Dictionary where Key: ExpressibleByStringLiteral {
    func JSONModelObjectValue<U: ModelObject>(modelObjectType: U.Type) -> U? {
        var JSONDictionary: JSONDict = JSONDict()
        
        // TO DO: Is there a more elegant way to do this?
        for (key, value) in self {
            guard let safeKey = key as? String else {
                continue
            }
            
            JSONDictionary[safeKey] = value as AnyObject
        }
        
        return U.self.init(JSONDictionary: JSONDictionary)
    }
    
    func JSONValueForKey<U>(key: String, type: U.Type, defaultValue: U? = nil) -> U? {
        if let keyValue = key as? Key, let value = self[keyValue] as? U {
            return value
        }
        
        return defaultValue
    }
    
    func JSONArrayValueForKey<U> (key: Key, elementType: U.Type) -> [U]? {
        if let value = self[key] as? [U] {
            return value
        }
        
        return nil;
    }
    
    func JSONModelObjectValueForKey<U: ModelObject>(key: String, modelObjectType: U.Type) -> U? {
        if let JSONDictionary = self.JSONValueForKey(key: key, type: JSONDict.self) {
            return U.self.init(JSONDictionary: JSONDictionary)
        }
        
        return nil
    }
    
    func JSONModelObjectListForKey<U: ModelObject>(key: String, modelObjectType: U.Type) -> [U]? {
        if let JSONArray = self.JSONValueForKey(key: key, type: Array<JSONDict>.self, defaultValue: nil) {
            var returnArray = [U]()
            
            for currentJSONDict in JSONArray {
                returnArray.append(U.self.init(JSONDictionary: currentJSONDict))
            }
            
            return returnArray
        }
        
        return nil
    }
    
    func JSONStringValueForKey(key: String, defaultValue: String? = nil) -> String? {
        return self.JSONValueForKey(key: key, type: String.self, defaultValue: defaultValue)
    }
    
    func JSONBoolValueForKey(key: String, defaultValue: Bool? = nil) -> Bool? {
        return self.JSONValueForKey(key: key, type: Bool.self, defaultValue: defaultValue)
    }
    
    func JSONIntValueForKey(key: String, defaultValue: Int? = nil) -> Int? {
        return self.JSONValueForKey(key: key, type: Int.self, defaultValue: defaultValue)
    }
    
    func JSONFloatValueForKey(key: String, defaultValue: Float? = nil) -> Float? {
        return self.JSONValueForKey(key: key, type: Float.self, defaultValue: defaultValue)
    }
    
    func JSONDoubleValueForKey(key: String, defaultValue: Double? = nil) -> Double? {
        return self.JSONValueForKey(key: key, type: Double.self, defaultValue: defaultValue)
    }
    
    func JSONEnumValueForKey<U: RawRepresentable>(key: Key, enumType: U.Type, defaultValue: U? = nil) -> U? {
        if let value = self[key] as? U.RawValue, let returnValue = U.self.init(rawValue: value) {
            return returnValue
        }
        
        return defaultValue
    }
    
    func JSONDateValueForKey(key: String, defaultValue: Date? = nil) -> Date? {
        guard let stringDate = self.JSONValueForKey(key: key, type: String.self, defaultValue: nil) else {
            return defaultValue
        }
        
        return ISO8601DateFormatter().date(from: stringDate)
    }
}
