//
//  JankenponCountdownView.swift
//  swiftui-experiment
//
//  Created by Augusto Avelino on 12/04/24.
//

import SwiftUI

struct JankenponCountdownView: View {
    @Binding var shouldStart: Bool
    private var isAnimating: Bool { shouldStart }
    @State private(set) var currentState: DisplayState = .hidden
    var completion: (() -> Void)?
    
    var body: some View {
        VStack {
            ZStack {
                janView
                kenView
                ponView
            }
        }
        .onChange(of: shouldStart) {
            if shouldStart {
                start()                
            } else {
                currentState = .hidden
            }
        }
    }
    
    @ViewBuilder
    private var janView: some View {
        let scale = currentState == .ken ? 3.0 : currentState == .jan ? 2.0 : 1.0
        Text("Jan")
            .font(.largeTitle)
            .fontWeight(.heavy)
            .opacity(currentState == .jan ? 1.0 : 0.0)
            .scaleEffect(scale)
    }
    
    @ViewBuilder
    private var kenView: some View {
        let scale = currentState == .pon ? 3.0 : currentState == .ken ? 2.0 : 1.0
        Text("Ken")
            .font(.largeTitle)
            .fontWeight(.heavy)
            .opacity(currentState == .ken ? 1.0 : 0.0)
            .scaleEffect(scale)
    }
    
    @ViewBuilder
    private var ponView: some View {
        let scale = currentState == .hidden ? 3.0 : currentState == .pon ? 2.0 : 1.0
        Text("Pon")
            .font(.largeTitle)
            .fontWeight(.heavy)
            .opacity(currentState == .pon ? 1.0 : 0.0)
            .scaleEffect(scale)
    }
    
    func start() {
        animateAfterDelay(0.0) {
            currentState = .jan
        } completion: {
            animateAfterDelay {
                currentState = .ken
            } completion: {
                animateAfterDelay {
                    currentState = .pon
                } completion: {
                    animateAfterDelay {
                        currentState = .hidden
                    } completion: {
                        completion?()
                    }
                }
            }
        }
    }
    
    private func animateAfterDelay(_ delay: TimeInterval = 0.2, animationBody: @escaping () -> Void, completion: (() -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            guard isAnimating else { return }
            withAnimation {
                animationBody()
            } completion: {
                completion?()
            }
        }
    }
}

extension JankenponCountdownView {
    enum DisplayState {
        case hidden, jan, ken, pon
    }
}

#Preview {
    @State var shouldStart = false
    return JankenponCountdownView(shouldStart: $shouldStart)
}
