import Vapor
import Authentication
import Errors
import Foundation

public let teamMiddlewareKey = "team_id_middleware_registered"

extension Request {
    public func accessToken()throws -> String {
        guard let bearer = self.http.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized)
        }
        return bearer
    }
    
    public func payload<Payload: Decodable>(as payloadType: Payload.Type = Payload.self)throws -> Payload {
        guard let payload = try self.get("skelpo-payload") as? Payload else {
            throw SkelpoMiddlewareError.middlewareNotRegistered("JWTAuthenticationMiddleware")
        }
        return payload
    }
    
    public func payloadData<Payload, Object>(storedAs stored: Payload.Type, convertedTo objectType: Object.Type = Object.self)throws -> Object
        where Payload: Encodable, Object: Decodable {
            guard let payload = try self.get("skelpo-payload") as? Payload else {
                throw SkelpoMiddlewareError.middlewareNotRegistered("JWTAuthenticationMiddleware")
            }
            let data: Data = try JSONEncoder().encode(payload)
            return try JSONDecoder().decode(Object.self, from: data)
    }
    
    @discardableResult
    public func teams(_ teams: [Int]? = nil)throws -> [Int] {
        let session = try self.session()
        if let ids = teams {
            try session.set("teams", to: ids)
        }
        
        if let teams: [Int] = try session.get("teams", as: [Int]?.self) {
            return teams
        } else if let teams = try self.get("skelpo_teams") as? [Int] {
            return teams
        } else {
            if let _ = try self.get(teamMiddlewareKey) {
                return []
            } else {
                throw SkelpoMiddlewareError.middlewareNotRegistered("TeamIDMiddleware")
            }            
        }
    }
}
