//
//  CodeTextView.swift
//  Learning
//
//  Created by Rafael Rodrigues on 03/06/21.
//

import SwiftUI

struct CodeTextView: UIViewRepresentable {
    
    @EnvironmentObject var model: ContentModel
    
    func makeUIView(context: Context) -> UITextView {
        
        let textView = UITextView()
        textView.attributedText = model.lessonDescription
        
        return textView
    }
    
    func updateUIView(_ textView: UITextView, context: Context) {
        
        // Set the attributed text for the lesson
        textView.attributedText = model.lessonDescription
        
        // Scroll back to the top
        textView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
    }
    
}

struct CodeTextView_Previews: PreviewProvider {
    static var previews: some View {
        CodeTextView()
    }
}
