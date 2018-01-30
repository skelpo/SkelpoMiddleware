import Service

public struct Storage: Service {
    var cache: [String: Codable] = [:]
}
