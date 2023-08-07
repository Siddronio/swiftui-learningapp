//
//  TestView.swift
//  Learning App
//
//  Created by Jhonatan Sidrônio on 31/07/23.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model:ContentModel
    
    // Track the answer selected
    @State var selectedAnswerIndex:Int?
    
    // Check the state wheter is submitted or not
    @State var submitted = false
    
    // Track the score of correct answers
    @State var numCorrect = 0

    
    
    
    var body: some View {
        
        if model.currentQuestion != nil {
            
            VStack(alignment: .leading) {
                
                // Question Number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)
                
                // Question
                CodeTextView()
                    .padding(.horizontal, 20)
                
                // Answers
                ScrollView {
                    VStack {
                        ForEach(0..<model.currentQuestion!.answers.count, id: \.self) { index in
                            
                            Button {
                                // Track the selected index
                                selectedAnswerIndex = index
                                
                            } label: {
                                ZStack {
                                    
                                    // If the user haven't hit the submit button yet, he stiil wil be able to select the answer
                                    if submitted == false {
                                        RectangleCard(color: index == selectedAnswerIndex ? .gray : .white)
                                            .frame(height: 48)
                                    }
                                    else {
                                        // Answer has been submitted
                                        // If this button is the answer I've selected and it's correct one, then show a green rectangle card
                                        if index == selectedAnswerIndex &&
                                            index == model.currentQuestion!.correctIndex {
                                            
                                            // Show a green background
                                            RectangleCard(color: .green)
                                                .frame(height: 48)
                                        }
                                        // If this button is the answer I've selected and it's NOT the correct one, then show a red rectangle card
                                        else if index == selectedAnswerIndex &&
                                                    index != model.currentQuestion!.correctIndex {
                                            
                                            // Show a red background
                                            RectangleCard(color: .red)
                                                .frame(height: 48)
                                        }
                                        else if  index == model.currentQuestion!.correctIndex {
                                            
                                            // This button is the correct answer
                                            // Show a green background
                                            RectangleCard(color: .green)
                                                .frame(height: 48)
                                        }
                                        else {
                                            RectangleCard(color: .white)
                                                .frame(height: 48)
                                        }
                                    }
                                    Text(model.currentQuestion!.answers[index])
                                    
                                }
                                
                            }
                            // You can use the .disabled modifier on a button and pass in a boolean value to determine whether or not the button will work
                            // Disabled the button if the answer is already submitted, so .disabled is going to be true if submitted is true
                            .disabled(submitted)
                        }
                    }
                    .accentColor(.black)
                    .padding()
                }
                
                // Submit Button - It will be used to submit the answers and move to the next question
                Button {
                    
                    // Check if answer has been submitted
                    if submitted == true {
                       // Answer has already been submitted, move to the next question
                        model.nextQuestion()
                        
                        // Reset properties
                        submitted = false
                        selectedAnswerIndex = nil
                        
                    }
                    else {
                        // Submit the answer
                        
                        
                        // Change the submitted state to true
                        submitted = true
                        
                        // Check the answer and increment the counter if correct
                        if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                            numCorrect += 1
                        }
                    }
                    
                } label: {
                    ZStack {
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        
                        Text(buttonText)
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding()
                    
                }
                // If I haven't selected any answer, I shouldn't be able to hit submit, so if (selectedAnswerIndex == nil) is true, this button is going to be disabled.
                .disabled(selectedAnswerIndex == nil)
            }
            .navigationTitle("\(model.currentModule?.category ?? "") Test")
            
        }
        else {
            // If the current question is nil, we show the result view
           TestResultView(numCorrect: numCorrect)
        }
    }
    
    // Computed Property - provides a getter and an optional setter to indirectly access other properties and values.
    var buttonText:String {
        
        // Check if answer has been submitted
        if submitted == true {
            if model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count {
                // This is the last question
                return "Finish"
            }
            else {
                // There is a next question
                return "Next"
            }
        }
        else {
            return "Submit"
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
            .environmentObject(ContentModel())
    }
}
