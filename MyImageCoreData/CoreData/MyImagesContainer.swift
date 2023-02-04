//
//  MyImagesContainer.swift
//  MyImageCoreData
//
//  Created by Nazar Prysiazhnyi on 04.02.2023.
//

import Foundation
import CoreData
import OSLog

let myLogger = Logger()

class MyImagesContainer {
    let persistantContainer: NSPersistentContainer
    
    init() {
        persistantContainer  = NSPersistentContainer(name: "MyImagesDataModel")
        persistantContainer.loadPersistentStores { _, error in
            if let error {
                myLogger.error("Could not create 'MyImagesDataModel' with error: \(error.localizedDescription)")
            }
        }
    }
}
