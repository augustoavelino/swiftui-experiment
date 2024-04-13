//
//  ShrinkingButtonStyle.swift
//  swiftui-experiment
//
//  Created by Augusto Avelino on 12/04/24.
//

import SwiftUI

struct ShrinkingButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    
    init(backgroundColor: Color = .blue, foregroundColor: Color = .white) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.largeTitle))
            .fontWeight(.bold)
            .padding()
            .background(backgroundColor)
            .foregroundStyle(foregroundColor)
            .clipShape(.rect(cornerRadius: 25))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}
