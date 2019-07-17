//
//  ContentView.swift
//  SwifterUI
//
//  Created by uke on 2019/7/17.
//  Copyright © 2019 uke. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    var body: some View {
        NavigationView {
            ScrollView(alwaysBounceHorizontal: true) {
                HStack(alignment: .top, spacing: 10) {
                    CardView()
                    CardView()
                    CardView()
                    CardView()
                    }
                    .padding([.top, .leading, .trailing], 20.0)
                }
                .navigationBarTitle(Text("Today"), displayMode: NavigationBarItem.TitleDisplayMode.inline)

            
        }
//        .edgesIgnoringSafeArea(.top)
        
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
