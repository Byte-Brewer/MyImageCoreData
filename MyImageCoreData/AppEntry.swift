//
//  MyImageCoreDataApp.swift
//  MyImageCoreData
//
//  Created by Nazar Prysiazhnyi on 04.02.2023.
//

import SwiftUI

@main
struct AppEntry: App {
    var body: some Scene {
        WindowGroup {
            MyImagesGridView()
                .environment(
                    \.managedObjectContext,
                     MyImagesContainer().persistantContainer.viewContext
                )
                .onAppear {
                    myLogger.debug("path where located my data: \(URL.documentsDirectory.path)")
                }
        }
    }
}
