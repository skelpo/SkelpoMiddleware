import Vapor
import Helpers

public final class TeamIDMiddleware: Middleware {
    public init() {}
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
        let payload = try request.payload()
        let teams: [Int]? = try payload.get("team_ids")
        
        try request.set("skelpo_teams", to: teams)
        try request.set(teamMiddlewareKey, to: true)
        
        return try next.respond(to: request)
    }
}
