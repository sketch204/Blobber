import Foundation

public protocol BlobberPersistenceManager {
    func data(for id: Blob.ID) async throws -> Data?
    func save(data: Data, for id: Blob.ID) async throws
}
