//
//  MyImageCoreDataApp.swift
//  MyImageCoreData
//
//  Created by Nazar Prysiazhnyi on 04.02.2023.
//

import SwiftUI

@main
struct AppEntry: App {
    @StateObject var shareService = SharedService()
    var body: some Scene {
        WindowGroup {
            MyImagesGridView()
                .environment(
                    \.managedObjectContext,
                     MyImagesContainer().persistantContainer.viewContext
                )
                .environmentObject(shareService)
                .onAppear {
                    myLogger.debug("path where located my document directory: \(URL.documentsDirectory.path)")
                }
        }
    }
}
