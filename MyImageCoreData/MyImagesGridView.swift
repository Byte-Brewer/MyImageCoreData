//
//  ContentView.swift
//  MyImageCoreData
//
//  Created by Nazar Prysiazhnyi on 04.02.2023.
//

import SwiftUI
import PhotosUI

struct MyImagesGridView: View {
    @EnvironmentObject var sharedService: SharedService
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)])
    private var myImages: FetchedResults<MyImage>
    @StateObject private var imagePicker = ImagePicker()
    @State private var formType: FormType?
    @State private var imageExist = false
    let columns = [GridItem(.adaptive(minimum: 100.0))]
    var body: some View {
        NavigationStack {
            Group {
                if !myImages.isEmpty {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20.0) {
                            ForEach(myImages) { myImage in
                                Button {
                                    formType = .update(myImage)
                                } label: {
                                    VStack {
                                        Image(uiImage: myImage.uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100.0, height: 100.0)
                                            .clipped()
                                            .shadow(radius: 5.0)
                                        Text(myImage.nameView)
                                    }
                                }
                                
                            }
                        }
                    }
                    .padding()
                } else {
                    Text("Select your first Images")
                }
            }
            .navigationTitle("My Images")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    PhotosPicker("New Image",
                                 selection: $imagePicker.imageSelection,
                                 matching: .images,
                                 photoLibrary: .shared())
                    .buttonStyle(.borderedProminent)
                }
            }
            .onChange(of: imagePicker.uiImage) { newValue in
                if let newValue {
                    formType = .new(newValue)
                }
            }
            .onChange(of: sharedService.codableImage) { codableImage in
                if let codableImage {
                    if let myImage = myImages.first(where: {$0.id == codableImage.id}) {
                        updateImageInfo(myImage: myImage)
                        imageExist.toggle()
                    } else {
                        restoreMyImage()
                    }
                }
            }
            .sheet(item: $formType) { $0 }
            .alert("Image Updated", isPresented: $imageExist) {
                Button("OK") {}
            }
        }
    }
    
    private func restoreMyImage() {
        if let codableImage = sharedService.codableImage {
            let newImage = MyImage(context: moc)
            newImage.id = codableImage.id
            newImage.name = codableImage.name
            newImage.comment = codableImage.comment
            newImage.dateTaken = codableImage.dateTaken
            newImage.receivedFrom = codableImage.receivedFrom
            try? moc.save()
        }
        sharedService.codableImage = nil
    }
    
    private func updateImageInfo(myImage: MyImage) {
        if let codableImage = sharedService.codableImage {
            myImage.id = codableImage.id
            myImage.name = codableImage.name
            myImage.comment = codableImage.comment
            myImage.dateTaken = codableImage.dateTaken
            myImage.receivedFrom = codableImage.receivedFrom
            try? moc.save()
        }
        sharedService.codableImage = nil
    }
}

struct MyImagesGridView_Previews: PreviewProvider {
    static var previews: some View {
        MyImagesGridView().environmentObject(SharedService())
    }
}
