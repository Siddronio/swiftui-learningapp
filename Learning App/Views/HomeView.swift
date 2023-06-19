//
//  HomeView.swift
//  Learning App
//
//  Created by Jhonatan Sidrônio on 19/06/23.
//

import SwiftUI

struct HomeView: View {
    
   @EnvironmentObject var model:ContentModel
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
