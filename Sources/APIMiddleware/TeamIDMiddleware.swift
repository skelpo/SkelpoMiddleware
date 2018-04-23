import VaporRequestStorage
import JWTMiddleware
import Vapor

public let teamMiddlewareKey = "team_id_middleware_registered"

public final class TeamIDMiddleware<PayloadType: Codable>: Middleware {
    public init() {}
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
        let teams = try request.payloadData(storedAs: PayloadType.self, convertedTo: TeamIDs.self).ids
 
        try request.set("skelpo_teams", to: teams)
        try request.set(teamMiddlewareKey, to: true)
        
        return try next.respond(to: request)
    }
}

fileprivate class TeamIDs: Decodable {
    let ids: [Int]?
}
