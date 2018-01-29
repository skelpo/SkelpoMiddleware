import Service

internal struct Storage: Service {
    var cache: [String: Codable] = [:]
}
