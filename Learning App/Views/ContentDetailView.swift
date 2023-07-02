//
//  ContentDetailView.swift
//  Learning App
//
//  Created by Jhonatan Sidrônio on 29/06/23.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    
    @EnvironmentObject var model:ContentModel
    
    var body: some View {
        
        let lesson = model.currentLesson
        // Optional Chaining and Nil Coalescing - Providing a option in case the lesson video is nil, if happens to be nil, set to a empty string
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        VStack {
            // Only show video if we get a valid URL
            if url != nil {
                VideoPlayer(player: AVPlayer(url: url!))
                    .cornerRadius(10)
            }
            
            // TODO: Description
            
            
            // Show next lesson button, only if there is a next lesson
            // Before create, we need to check if have a next lesson with a function in ContentModel
            if model.hasNextLession() {
                Button {
                    // Advance the lesson
                    model.nextLesson()
                } label: {
                    
                    ZStack {
                        
                        Rectangle()
                            .frame(height: 48)
                            .foregroundColor(.green)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                            .foregroundColor(.white)
                            .bold()

                    }
                }
            }
            

        }
        .padding()
        .navigationTitle(lesson?.title ?? "")
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
            .environmentObject(ContentModel())
    }
}
