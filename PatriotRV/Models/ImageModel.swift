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
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(uiImage: uiImage)
                return ChecklistImage(image: image)
            }
        }
    }
}
