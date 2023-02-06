//
//  FileManager+Extension.swift
//  MyImageCoreData
//
//  Created by Nazar Prysiazhnyi on 05.02.2023.
//

import Foundation
import UIKit

extension FileManager {
    func retriveImage(with id: String) -> UIImage? {
        let url = URL.documentsDirectory.appendingPathComponent("\(id).jpeg")
        do {
            let imageData = try Data(contentsOf: url)
            return UIImage(data: imageData)
        } catch {
            myLogger.error("Could not find image for url: \(url) with error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func saveImage(with id: String, image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.6) {
            do {
                let url = URL.documentsDirectory.appendingPathComponent("\(id).jpeg")
                try data.write(to: url)
            } catch {
                myLogger.error("Could not write image with error: \(error.localizedDescription)")
            }
        } else {
            myLogger.error("Could not save image")
        }
    }
    
    func deleteImage(with id: String) {
        let url = URL.documentsDirectory.appendingPathComponent("\(id).jpeg")
        if fileExists(atPath: url.path) {
            do {
                try removeItem(at: url)
            } catch {
                myLogger.error("Could not deleta image with error: \(error.localizedDescription)")
            }
        } else {
            myLogger.error("Image does not exist")
        }
    }
    
    func saveJSON(_ json: String, fileName: String) {
        let url = URL.documentsDirectory.appending(path: fileName)
        do {
            try json.write(to: url, atomically: false, encoding: .utf8)
        } catch {
            myLogger.error("Could not save url: \(url) \n with error: \(error.localizedDescription)")
        }
    }
    
    func decodeJSON(from url: URL) -> CodableImage? {
        do {
            let data = try Data(contentsOf: url)
            do {
                return try JSONDecoder().decode(CodableImage.self, from: data)
            } catch {
                myLogger.error("Could not decode data with error: \(error.localizedDescription)")
                return nil
            }
        } catch {
            myLogger.error("Could not take data from url: \(url)\n with error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func moveFile(oldURL: URL, newURL: URL) {
        if fileExists(atPath: newURL.path) {
            try? removeItem(at: newURL)
        }
        do {
            try moveItem(at: oldURL, to: newURL)
        } catch {
            myLogger.error("Could not move url's: \(oldURL)\n \(newURL)\n with error: \(error.localizedDescription)")
        }
    }
}
