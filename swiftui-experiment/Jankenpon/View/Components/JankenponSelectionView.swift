//
//  JankenponSelectionView.swift
//  swiftui-experiment
//
//  Created by Augusto Avelino on 12/04/24.
//

import SwiftUI

// MARK: View

struct JankenponSelectionView: View {
    private let options = Jankenpon.Option.allCases
    
    @State private var screenWidth: CGFloat = .zero
    @Binding var currentOption: Jankenpon.Option
    @State private var currentIndex: Int = 0
    
    private let coordinateSpaceName = UUID()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0.0) {
                ForEach(options) { option in
                    JankenponOptionView(option: option)
                }
            }
            .scrollTargetLayout()
            .background(GeometryReader { geometry in
                Color.clear.preference(key: OffsetPreferenceKey.self, value: geometry.frame(in: .named(coordinateSpaceName)).origin.x)
            })
            .onPreferenceChange(OffsetPreferenceKey.self, perform: { offset in
                let newIndex = Int(abs(offset) / max(1, screenWidth))
                if newIndex != currentIndex {
                    currentIndex = newIndex
                }
            })
        }
        .background(GeometryReader { geometry in
            Color.clear.preference(key: WidthPreferenceKey.self, value: geometry.size.width)
        })
        .scrollTargetBehavior(.paging)
        .coordinateSpace(name: coordinateSpaceName)
        .onPreferenceChange(WidthPreferenceKey.self, perform: { value in
            screenWidth = value
        })
        .onChange(of: currentIndex) {
            currentOption = options[currentIndex]
        }
    }
}

// MARK: - PreferenceKey

private extension JankenponSelectionView {
    struct OffsetPreferenceKey: PreferenceKey {
        static let defaultValue: CGFloat = .zero
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value += nextValue()
        }
    }
    
    struct WidthPreferenceKey: PreferenceKey {
        static let defaultValue: CGFloat = .zero
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
    }
}

// MARK: - Preview

#Preview {
    @State var currentOption: Jankenpon.Option = .rock
    return JankenponSelectionView(currentOption: $currentOption)
}
