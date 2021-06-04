//
//  ContentViewRow.swift
//  Learning
//
//  Created by Rafael Rodrigues on 03/06/21.
//

import SwiftUI

struct ContentViewRow: View {
    
    @EnvironmentObject var model: ContentModel
    var index: Int
    
    var body: some View {
        
        let lesson = model.currentModule!.content.lessons[index]
        
        // Lesson card
        ZStack(alignment: .leading) {
            
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(height: 76)
            
            HStack(spacing: 30.0) {
                
                Text(String(index + 1))
                    .bold()
                
                VStack(alignment: .leading) {
                    Text(lesson.title)
                        .font(.title3)
                        .bold()
                    Text(lesson.duration)
                        .font(.subheadline)
                }
            }
            .padding()
        }
        .padding(.top, 10.0)
    }
}
