//
//  TestResultView.swift
//  Learning App
//
//  Created by Jhonatan Sidrônio on 01/08/23.
//

import SwiftUI

struct TestResultView: View {
    
    @EnvironmentObject var model:ContentModel
    
    var numCorrect:Int
    
    var resultHeading:String {
        
        guard model.currentModule != nil else {
            return ""
        }
        
        let pct = Double(numCorrect) / Double(model.currentModule!.test.questions.count)
        
        if pct > 0.5 {
            return "Awesome!"
        }
        else if pct > 0.2 {
            return "Doing great!"
        }
        else {
           return "Keep learning."
        }
        
    }
    
    var body: some View {
        
        VStack {
            Spacer()
            
            Text(resultHeading)
                .bold()
                .font(.title)

            Spacer()
            
            // Converting Int values to Double values will allow us to get decimals
            Text("You got \(numCorrect) out of \(model.currentModule?.test.questions.count ?? 0) questions")
            
            Spacer()
            
            Button {
                // Send the user back to the home view
                model.currentTestSelected = nil
                
            } label: {
                ZStack {
                    RectangleCard(color: .green)
                        .frame(height: 48)
                    
                    Text("Complete")
                        .bold()
                        .foregroundColor(.white)
                }
            }
            .padding()
            Spacer()

        
        }
        
        
        
    }
}


