//
//  ShareService.swift
//  MyImageCoreData
//
//  Created by Nazar Prysiazhnyi on 06.02.2023.
//

import Foundation
import ZIPFoundation

struct CodableImage: Codable, Equatable {
    let comment: String
    let dateTaken: Date
    let id: String
    let name: String
    let receivedFrom: String
}

class SharedService: ObservableObject {
    @Published var codableImage: CodableImage?
    static let ext = "myimg"
    func saveMyImage(_ codableImage: CodableImage) {
        let fileName = "\(codableImage.id).json"
        do {
            let data = try JSONEncoder().encode(codableImage)
            let jsonString = String(decoding: data, as: UTF8.self)
            FileManager().saveJSON(jsonString, fileName: fileName)
            zipFiles(id: codableImage.id)
        } catch {
            myLogger.error("Could not Encode codableImage with error: \(error.localizedDescription)")
        }
    }
    
    func restore(url: URL) {
        let fileName = url.lastPathComponent
        let jsonName = fileName.replacingOccurrences(of: SharedService.ext, with: "json")
        let zipName = fileName.replacingOccurrences(of: SharedService.ext, with: "zip")
        let imageName = fileName.replacingOccurrences(of: SharedService.ext, with: "jpeg")
        let imgURL = URL.documentsDirectory.appending(path: imageName)
        let zipURL = URL.documentsDirectory.appending(path: zipName)
        let unzippedJSONURL = URL.documentsDirectory.appending(path: jsonName)
        if url.pathExtension == Self.ext {
            try? FileManager().moveItem(at: url, to: zipURL)
            try? FileManager().removeItem(at: imgURL)
            do {
                try FileManager().unzipItem(at: zipURL, to: URL.documentsDirectory)
            } catch {
                myLogger.error("Could not unzipItem with error: \(error.localizedDescription)")
            }
            if let codableImage = FileManager().decodeJSON(from: URL.documentsDirectory.appending(path: jsonName)) {
                self.codableImage = codableImage
            }
        }
        try? FileManager().removeItem(at: zipURL)
        try? FileManager().removeItem(at: unzippedJSONURL)
    }
    
    func zipFiles(id: String) {
        let archiveURL = URL.documentsDirectory.appending(path: "\(id).\(Self.ext)")
        guard let archive = Archive(url: archiveURL, accessMode: .create) else { return }
        
        let imageURL = URL.documentsDirectory.appending(path: "\(id).jpeg")
        let jsonURL = URL.documentsDirectory.appending(path: "\(id).json")
        do {
            try archive.addEntry(with: imageURL.lastPathComponent, relativeTo: URL.documentsDirectory)
            try archive.addEntry(with: jsonURL.lastPathComponent, relativeTo: URL.documentsDirectory)
            try FileManager().removeItem(at: jsonURL)
        } catch {
            myLogger.error("Could not addEntry to archive with error: \(error.localizedDescription)")
        }
    }
}
