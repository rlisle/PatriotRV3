//
//  PhotoView.swift
//  PatriotRV
//
//  Created by Ron Lisle on 4/14/23.
//

import SwiftUI
import PhotosUI

struct PhotoView: View {
  enum Size: Double {
    case cell
    case detail

    func width(isPlaceHolder: Bool = false) -> Double {
      switch self {
      case .cell:
        return isPlaceHolder ? 45.0 : 50.0
      case .detail:
        return isPlaceHolder ? 100.0 : 150.0
      }
    }
  }

  var photoData: Data?
  var size: Size

  var body: some View {
    if let photoData,
      let uiImage = UIImage(data: photoData) {
      let imageSize = size.width(isPlaceHolder: false)

      Image(uiImage: uiImage)
        .resizable()
        .frame(width: imageSize, height: imageSize)
        .cornerRadius(10)
    } else {
      let imageSize = size.width()

      Image(systemName: "photo")
        .foregroundColor(.accentColor)
        .font(.system(size: imageSize))
    }
  }
}

struct PhotoView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      PhotoView(size: .cell)
            .previewDisplayName("Cell")
      PhotoView(size: .detail)
            .previewDisplayName("Detail")
    }
  }
}
