//
//  ImageModel.swift
//  PatriotRV
//
//  Created by Ron Lisle on 4/13/23.
//

import SwiftUI
import PhotosUI
import CoreTransferable

//@MainActor - already marked
extension ViewModel {
    
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }
    
    enum TransferError: Error {
        case importFailed
    }

    struct ChecklistImage: Transferable {
        let image: Image
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
            #if canImport(AppKit)
                guard let nsImage = NSImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(nsImage: nsImage)
                return ProfileImage(image: image)
            #elseif canImport(UIKit)
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(uiImage: uiImage)
                return ChecklistImage(image: image)
            #else
                throw TransferError.importFailed
            #endif
            }
        }
    }
}
