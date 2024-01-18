import Foundation

#if os(iOS) || os(tvOS)
import UIKit
public typealias PlatformImage = UIImage
#elseif os(macOS)
import AppKit
public typealias PlatformImage = NSImage
#endif

extension Blobber {
    public struct InvalidImageError: Error, CustomStringConvertible {
        public var description: String {
            "Unable to convert image to data!"
        }
    }
    
    public func image(for id: Blob.ID) async throws -> PlatformImage? {
        guard let blob = try await blob(for: id) else { return nil }
        return PlatformImage(data: blob.data)
    }
    
    public func store(_ image: PlatformImage, for id: Blob.ID?) async throws -> Blob {
        let data = try imageData(from: image)
        
        return try await store(data, for: id)
    }
    
    private func imageData(from image: PlatformImage) throws -> Data {
        #if os(iOS) || os(tvOS)
        return image.jpegData(compressionQuality: 1.0)
        #elseif os(macOS)
        guard let tiffRepresentation = image.tiffRepresentation,
              let imageRep = NSBitmapImageRep(data: tiffRepresentation),
              let imageData = imageRep.representation(using: .png, properties: [:])
        else {
            throw InvalidImageError()
        }
        return imageData
        #endif
    }

}
