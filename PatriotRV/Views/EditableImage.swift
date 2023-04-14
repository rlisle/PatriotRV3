//
//  EditableImage.swift
//  PatriotRV
//
//  Created by Ron Lisle on 4/13/23.
//

import SwiftUI
import PhotosUI

struct EditableImage: View {
    
    @EnvironmentObject var model: ViewModel

    var body: some View {
        ChecklistImage(imageState: model.imageState)
        .overlay(alignment: .topTrailing) {
            PhotosPicker(selection: $model.imageSelection,
                         matching: .any(of: [.images, .not(.screenshots)]),
                         photoLibrary: .shared()) {
                Image(systemName: "pencil.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 30))
                    .foregroundColor(.accentColor)
            }
                         .buttonStyle(.borderless)
        }
    }
}

struct ChecklistImage: View {
    let imageState: ViewModel.ImageState
    
    var body: some View {
        switch imageState {
        case .success(let image):
            image.resizable()
        case .loading:
            ProgressView()
        case .empty:
            Image(systemName: "person.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
    }
}

struct EditableImage_Previews: PreviewProvider {
    static var previews: some View {
        EditableImage()
            .environmentObject(ViewModel())
    }
}
