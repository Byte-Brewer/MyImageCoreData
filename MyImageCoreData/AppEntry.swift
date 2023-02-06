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
    let moc = MyImagesContainer().persistantContainer.viewContext
    var body: some Scene {
        WindowGroup {
            MyImagesGridView()
                .environment(\.managedObjectContext, moc)
                .environmentObject(shareService)
                .onAppear {
                    myLogger.debug("path where located my document directory: \(URL.documentsDirectory.path)")
                }
                .onOpenURL { url in
                    shareService.restore(url: url)
                }
        }
    }
}
