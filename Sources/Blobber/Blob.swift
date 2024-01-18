import Foundation

public struct Blob: Identifiable {
    public let id: ID
    public let data: Data
}

extension Blob {
    public struct ID: RawRepresentable, Hashable {
        public var rawValue: UUID
        
        public init() {
            self.init(rawValue: UUID())
        }
        
        public init(rawValue: UUID) {
            self.rawValue = rawValue
        }
    }
}
