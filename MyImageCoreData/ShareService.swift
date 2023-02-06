//
//  ShareService.swift
//  MyImageCoreData
//
//  Created by Nazar Prysiazhnyi on 06.02.2023.
//

import Foundation

struct CodableImage: Codable, Equatable {
    let comment: String
    let dateTaken: Date
    let id: String
    let name: String
    let receivedFrom: String
}

class SharedService: ObservableObject {
    static let ext = "myimg"
    func saveMyImage(_ codableImage: CodableImage) {
        let fileName = "\(codableImage.id).\(Self.ext)"
        do {
            let data = try JSONEncoder().encode(codableImage)
            let jsonString = String(decoding: data, as: UTF8.self)
            FileManager().saveJSON(jsonString, fileName: fileName)
        } catch {
            myLogger.error("Could not Encode codableImage with error: \(error.localizedDescription)")
        }
    }
}
