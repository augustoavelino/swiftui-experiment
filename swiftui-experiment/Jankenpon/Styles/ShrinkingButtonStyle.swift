//
//  ShrinkingButtonStyle.swift
//  swiftui-experiment
//
//  Created by Augusto Avelino on 12/04/24.
//

import SwiftUI

struct ShrinkingButtonStyle: ButtonStyle {
    let buttonSize: ButtonSize
    let backgroundColor: Color
    let foregroundColor: Color
    
    init(_ buttonSize: ButtonSize = .medium, backgroundColor: Color = .blue, foregroundColor: Color = .white) {
        self.buttonSize = buttonSize
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        let isSmall = buttonSize == .small
        let font: Font = isSmall ? .system(.title3) : .system(.largeTitle)
        return configuration.label
            .font(font)
            .fontWeight(.bold)
            .padding()
            .background(backgroundColor)
            .foregroundStyle(foregroundColor)
            .clipShape(.rect(cornerRadius: isSmall ? 20 : 25))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension ShrinkingButtonStyle {
    enum ButtonSize {
        case small, medium
    }
}
