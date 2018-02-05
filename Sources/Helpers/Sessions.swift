import Vapor
import Foundation

extension Session {
    public func set<Value: Codable>(_ key: String, to value: Value)throws {
        self[key] = try String(data: JSONEncoder().encode(value), encoding: .utf8)
    }
    
    public func get<Value: Codable>(_ key: String, as type: Value.Type)throws -> Value {
        guard let data = self[key]?.data(using: .utf8) else {
            throw Abort(.internalServerError, reason: "Unable to convert `String` stored in session to `Data`")
        }
        return try JSONDecoder().decode(Value.self, from: data)
    }
}
