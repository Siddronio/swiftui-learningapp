//
//  CodeTextView.swift
//  Learning App
//
//  Created by Jhonatan Sidrônio on 29/07/23.
//

import SwiftUI

// In a UIViewRepresentable, the function makeUIView is required to create the initial view object and the updateUIView will update the state of the view
struct CodeTextView: UIViewRepresentable {
    
    @EnvironmentObject var model: ContentModel
    
    func makeUIView(context: Context) -> UITextView {
        
        let textView = UITextView()
        textView.isEditable = false
        
        return textView
    }
    
    func updateUIView(_ textView: UITextView, context: Context) {
        
        // Set the attributed text for the lesson
        textView.attributedText = model.codeText
        
        // Scroll back to the top when you tap on the next lesson button
        textView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
        
    }
    
}

struct CodeTextView_Previews: PreviewProvider {
    static var previews: some View {
        CodeTextView()
    }
}
