import Authentication
import Vapor
import JWT

public protocol IdentifiableJWTPayload: JWTPayload {
    associatedtype ID
    
    var id: ID { get }
}

public protocol JWTAuthenticatable: Authenticatable, Content where Payload.ID == Self.ID {
    associatedtype Payload: IdentifiableJWTPayload
    static var usernameKey: KeyPath<Self, String> { get }
    
    var password: String { get }
    
    func accessToken(on request: Request)throws -> Future<String>
}
