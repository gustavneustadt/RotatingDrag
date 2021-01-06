//
//  KnobView.swift
//  RotatingDrag
//
//  Created by Gustav on 06.01.21.
//

import SwiftUI

struct KnobView: View {
    @State var size = CGSize(width: 200, height: 200)
    
    var body: some View {
        ZStack(alignment:.trailing) {
            Circle()
                .foregroundColor(Color(UIColor.lightGray))
            Capsule()
                .frame(width: size.height > size.width ? size.height / 3.5 : size.width / 3.5 , height: size.height > size.width ? size.height / 20 : size.width / 20)
                .foregroundColor(.yellow)
                .padding()
            
        }
        .frame(width:size.width, height:size.height)
    }
}

//struct KnobView_Previews: PreviewProvider {
//    static var previews: some View {
//        KnobView(angle: .constant(Angle(degrees: 0)))
//    }
//}
