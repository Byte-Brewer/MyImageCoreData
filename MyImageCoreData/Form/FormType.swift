//
//  FormType.swift
//  MyImageCoreData
//
//  Created by Nazar Prysiazhnyi on 05.02.2023.
//

import SwiftUI

enum FormType: Identifiable, View {
    case new(UIImage)
    case update(MyImage)
    
    var id: String {
        switch self {
        case .new:
            return "new"
        case .update:
            return "update"
        }
    }
    
    var body: some View {
        switch self {
        case let .new(uiImage):
            return ImageFormView(viewModel: FormViewModel(uiImage))
        case let .update(myImage):
            return ImageFormView(viewModel: FormViewModel(myImage))
        }
    }
}
