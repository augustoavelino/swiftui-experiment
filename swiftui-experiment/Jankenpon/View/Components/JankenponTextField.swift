//
//  JankenponTextField.swift
//  swiftui-experiment
//
//  Created by Augusto Avelino on 16/04/24.
//

import SwiftUI

struct JankenponTextField: View {
    var placeholder = ""
    @Binding var text: String
    @Binding var isEditing: Bool
    
    var body: some View {
        TextField(
            placeholder,
            text: $text
        )
        .disabled(!isEditing)
        .overlay {
            HStack {
                Spacer()
                if isEditing {
                    Button(action: { text = "" }, label: {
                        Image(systemName: "xmark.circle.fill")
                    })
                }
            }
        }
    }
}
