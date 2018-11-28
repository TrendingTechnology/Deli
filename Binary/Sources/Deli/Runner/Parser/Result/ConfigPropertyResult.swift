//
//  ConfigPropertyResult.swift
//  Deli
//
//  Created by Kawoou on 28/11/2018.
//

final class ConfigPropertyResult: Results {
    var valueType: Bool
    var isLazy: Bool { return false }
    var isFactory: Bool { return false }
    var isRegister: Bool { return true }
    var instanceType: String
    var scope: String? = nil
    var qualifier: String? = nil
    var dependencies: [Dependency] = []
    var instanceDependency: [Dependency] = []
    var imports: [String] = []

    var linkType: Set<String> = Set()

    let propertyTargetKey: String
    let propertyKeys: [String]
    var propertyValues: [String] = []

    init(
        _ instanceType: String,
        _ propertyTargetKey: String,
        _ propertyKeys: [String],
        valueType: Bool
    ) {
        self.valueType = valueType
        self.instanceType = instanceType
        self.propertyTargetKey = propertyTargetKey
        self.propertyKeys = propertyKeys
    }
    func makeSource() -> String? {
        let properties = propertyKeys.enumerated()
            .map { (index, key) in
                if propertyKeys.count == index + 1 {
                    return "\(key): \"\(propertyValues[index])\""
                } else {
                    return "\(key): \"\(propertyValues[index])\","
                }
            }
            .joined(separator: "\n            ")

        return """
        register(
            \(instanceType).self,
            resolver: {
                return \(instanceType)(
                    \(properties)
                )
            },
            qualifier: "",
            scope: .prototype
        )
        """
    }
}
