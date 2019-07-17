//
//  CardView.swift
//  etc
//
//  Created by uke on 2019/7/17.
//  Copyright © 2019 uke. All rights reserved.
//

import SwiftUI

struct CardView : View {
    
//    let lv = LinearGradient(gradient: Gradient(colors: [Color.random, Color.random, Color.random]), startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1))
//    let lv = LinearGradient(gradient: Gradient(colors: [Color(color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)), Color(color: #colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1)), Color(color: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1))]), startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1))

    let lv = LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.5)), Color(#colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)), Color(#colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 0.5))]), startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1))

    let rv = RadialGradient(gradient: Gradient(colors: [Color.random, Color.random, Color.random]), center: .init(x: 0, y: 0), startRadius: 0, endRadius: 0.8)
    let av = AngularGradient(gradient: Gradient(colors: [Color.random, Color.random, Color.random]), center: .init(x: 0, y: 0))
    
    
    var body: some View {
        Image("login_bg")
            .frame(width: 200.0, height: 120.0)
//            .background(lv, cornerRadius: 10)
            .clipped()
            .blur(radius: 5)
            .shadow(color: Color(#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.5)), radius: 10, x: 0, y: 10)
            .overlay(
                Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
                    .background(lv, cornerRadius: 10)
            )
            .overlay(Text("Placeholder"))


        
//        Color(239, g: 120, b: 221, a: 1)
//        Color(color: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
//            .frame(width: 200.0, height: 120.0)

        
//        Image("login_bg")
//            .resizable()
//            .onAppear {
//
//        }
        
        
//            Circle()


        
//        RoundedRectangle(cornerRadius: 10)
//            .background(Color.red, cornerRadius: 3)
//            .frame(width: 200.0, height: 120.0)
//            .foregroundColor(.yellow)
//            .clipShape(
//                LinearGradient(gradient: Gradient(colors: [Self.gradientStart, Self.gradientEnd]),
//                               startPoint: .init(x: 0.5, y: 0),
//                               endPoint: .init(x: 0.5, y: 0.6)),
//                style: .init()
//        )
        
    }
}

#if DEBUG
struct CardView_Previews : PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
#endif
