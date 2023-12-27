//
//  SwiftUIView.swift
//  NewsApp
//
//  Created by Mariam Joglidze on 27.12.23.
//

import SwiftUI
struct TextSizeAdjustmentView: View {
    @Binding var textSize: CGFloat
    
    var body: some View {
        VStack {
            Text("Adjust Text Size")
                .font(.headline)
                .padding()
            
            Slider(value: $textSize, in: 10...100, step: 1)
                .padding()
        }
    }
}
