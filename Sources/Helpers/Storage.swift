import Service

public struct Storage: Service {
    public var cache: [String: Codable] = [:]
    
    public init() {}
}
