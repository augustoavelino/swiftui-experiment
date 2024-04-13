//
//  JankenponOptionView.swift
//  swiftui-experiment
//
//  Created by Augusto Avelino on 12/04/24.
//

import SwiftUI

struct JankenponOptionView: View {
    private(set) var option: Jankenpon.Option
    
    var body: some View {
        Text(text(for: option))
            .font(.system(size: 160))
            .containerRelativeFrame(.horizontal)
    }
    
    private func text(for option: Jankenpon.Option) -> String {
        switch option {
        case .rock: "✊"
        case .paper: "✋"
        case .scissors: "✌️"
        }
    }
}

#Preview {
    JankenponOptionView(option: .paper)
}
