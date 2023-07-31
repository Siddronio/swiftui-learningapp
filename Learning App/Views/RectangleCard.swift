//
//  RectangleCard.swift
//  Learning App
//
//  Created by Jhonatan Sidrônio on 03/07/23.
//

import SwiftUI

struct RectangleCard: View {
    
    // To make the rectangle dynamic, we create this property
    var color = Color(.white)
    
    var body: some View {
        
        Rectangle()
            .foregroundColor(color)
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}

struct RectangleCard_Previews: PreviewProvider {
    static var previews: some View {
        RectangleCard()
    }
}
