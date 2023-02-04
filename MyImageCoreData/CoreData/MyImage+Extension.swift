//
//  MyImage+Extension.swift
//  MyImageCoreData
//
//  Created by Nazar Prysiazhnyi on 04.02.2023.
//

import UIKit

extension MyImage {
    var nameView: String {
        name ?? ""
    }
    
    var imageID: String {
        id ?? ""
    }
    
    var uiImage: UIImage {
        if !imageID.isEmpty, let image = FileManager().retriveImage(with: imageID) {
            return image
        } else {
            return UIImage(systemName: "photo")!
        }
    }
}
