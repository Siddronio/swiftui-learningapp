//
//  ContentViewRow.swift
//  Learning App
//
//  Created by Jhonatan Sidrônio on 28/06/23.
//

import SwiftUI

struct ContentViewRow: View {
    
    @EnvironmentObject var model:ContentModel
    // We create a subview from ContentView to keep the things separately, for that is necessary to create a index just like the object model above
    var index:Int
    
    var body: some View {
        
        // To get a title and duration of the lesson, we create our own constant and we have the current lesson
        let lesson = model.currentModule!.content.lessons[index]
        
        // Lesson card
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(height: 66)
            
            HStack(spacing: 30) {
                Text(String(index + 1))
                    .bold()
                
                VStack(alignment: .leading) {
                    Text(lesson.title)
                        .bold()
                    Text(lesson.duration)
                }
            }
            .padding()
        }
        .padding(.bottom, 5)
        
    }
}

// We remove the preview because currentModule won't be set.
