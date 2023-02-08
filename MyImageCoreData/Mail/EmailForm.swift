//
//  EmailForm.swift
//  MyImageCoreData
//
//  Created by Nazar Prysiazhnyi on 08.02.2023.
//

import Foundation

struct EmailForm {
    var toAddress = ""
    var subject = ""
    var messageHeader = ""
    var data: Data?
    var fileName = ""
    var mimeType = "text/plain"
    var body: String {
        messageHeader.isEmpty ? "" : messageHeader + "\n"
    }
}
