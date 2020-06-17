import Foundation

// sourcery: InjectRegister = "StringReplaceUtil"
class StringReplaceUtil {
    private let environment: Environment

    init(environment: Environment) {
        self.environment = environment
    }

    func replace(_ string: String, values: ([String: String])? = nil) -> String {
        var string = string

        // Default keys and values to replace
        string = string.replacingOccurrences(of: StringReplaceTemplate.platform.rawValue, with: "iOS")
        string = string.replacingOccurrences(of: StringReplaceTemplate.appVersion.rawValue, with: environment.appVersion)
        string = string.replacingOccurrences(of: StringReplaceTemplate.appName.rawValue, with: Env.appName)

        values?.forEach { key, value in
            string = string.replacingOccurrences(of: "{{\(key)}}", with: value)
        }

        return string
    }
}

enum StringReplaceTemplate: String, CaseIterable {
    case platform = "{{platform}}"
    case appVersion = "{{app_version}}"
    case appName = "{{app_name}}"
}
