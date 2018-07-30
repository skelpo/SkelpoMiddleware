import VaporRequestStorage
import JWTMiddleware
import Foundation
import Vapor

// MARK: - Middleware

public let teamMiddlewareKey = "team_id_middleware_registered"

fileprivate class TeamIDs: Decodable {
    let teamIDs: [Int]?
}

public final class TeamIDMiddleware<PayloadType: Codable>: Middleware {
    public init() {}
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
        let teams = try request.payloadData(storedAs: PayloadType.self, convertedTo: TeamIDs.self).teamIDs
 
        try request.set("skelpo_teams", to: teams)
        try request.set(teamMiddlewareKey, to: true)
        
        return try next.respond(to: request)
    }
}

// MARK: - Helpers

extension Request {
    @discardableResult
    public func teams(_ teams: [Int]? = nil)throws -> [Int] {
        let session = try self.session()
        if let ids = teams {
            try session.set("teams", to: ids)
        }
        
        if let teams: [Int] = try session.get("teams", as: [Int]?.self) {
            return teams
        } else if let teams = try self.get("skelpo_teams", as: [Int].self) {
            return teams
        } else {
            if let _ = try self.get(teamMiddlewareKey, as: Bool.self) {
                return []
            } else {
                throw Abort(.internalServerError, reason: "TeamIDMiddleware has not been registered on the route you are attempting to get team IDs from")
            }
        }
    }
}

extension Session {
    public func set<Value: Codable>(_ key: String, to value: Value)throws {
        self[key] = try String(data: JSONEncoder().encode(value), encoding: .utf8)
    }
    
    public func get<Value: Codable>(_ key: String, as type: Value.Type = Value.self)throws -> Value {
        guard let data = self[key]?.data(using: .utf8) else {
            throw Abort(.internalServerError, reason: "Unable to convert `String` stored in session to `Data`")
        }
        return try JSONDecoder().decode(Value.self, from: data)
    }
    
    public func get<Value: Codable>(_ key: String, as type: Value?.Type = Value?.self)throws -> Value? {
        guard let json = self[key] else { return nil }
        guard let data = json.data(using: .utf8) else {
            throw Abort(.internalServerError, reason: "Unable to convert `String` stored in session to `Data`")
        }
        return try JSONDecoder().decode(Value.self, from: data)
    }
}
