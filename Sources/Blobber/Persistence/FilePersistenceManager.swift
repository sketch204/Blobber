import Foundation

public struct FilePersistenceManager {
    public let baseUrl: URL
    
    private var fileManager: FileManager { .default }
    
    public init(baseUrl: URL = defaultBaseUrl) {
        self.baseUrl = baseUrl
    }
}

extension FilePersistenceManager {
    public static var defaultBaseUrl: URL {
        try! FileManager.default
            .url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
    }
}

extension FilePersistenceManager: BlobberPersistenceManager {
    private func url(for id: Blob.ID) -> URL {
        baseUrl.appendingPathComponent(id.rawValue.uuidString)
    }
    
    public func data(for id: Blob.ID) async throws -> Data? {
        let url = url(for: id)
        guard fileManager.fileExists(atPath: url.path) else { return nil }
        return try Data(contentsOf: url)
    }
    
    public func save(data: Data, for id: Blob.ID) async throws {
        let url = url(for: id)
        try data.write(to: url)
    }
}
