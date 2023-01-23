//
//  ChecklistHeader.swift
//  RvChecklist
//
//  Created by Ron Lisle on 2/22/21.
//

import SwiftUI

struct ImageHeader: View {
    
    var imageName: String
    
    var body: some View {
        ZStack(alignment: .topLeading, content: {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
        })
    }
}

struct ChecklistHeader_Previews: PreviewProvider {
    static var previews: some View {
        ImageHeader(imageName: "rv-truck")
            .previewLayout(.fixed(width: 300, height: 210))
            .previewDisplayName("ChecklistHeader")
    }
}
