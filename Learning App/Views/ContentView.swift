//
//  ContentView.swift
//  Learning App
//
//  Created by Jhonatan Sidrônio on 26/06/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model:ContentModel
    
    var body: some View {
        
        ScrollView {
            LazyVStack {
                // Confirm that currentModule is set
                if model.currentModule != nil {
                    ForEach(0..<model.currentModule!.content.lessons.count, id: \.self) { index in
                        
                        NavigationLink {
                            ContentDetailView()
                                .onAppear {
                                    model.beginLesson(index)
                                }
                        } label: {
                            ContentViewRow(index: index)
                        }

                        
                    }
                }
            }
            .accentColor(.black)
            .padding()
            // Because currentModule is an optional (it could be nil), we're gonna use a nil coalescing operator and if no module is set, we'll use a empty string.
            .navigationTitle("Learn \(model.currentModule?.category ?? "")")
        }
    }
}

