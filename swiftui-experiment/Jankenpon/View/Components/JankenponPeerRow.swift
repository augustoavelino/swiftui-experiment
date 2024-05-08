//
//  JankenponPeerRow.swift
//  swiftui-experiment
//
//  Created by Augusto Avelino on 16/04/24.
//

import SwiftUI

struct JankenponPeerRow: View {
    var peerName: String
    var isPaired: Bool
    var onTap: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 16.0) {
            Image(systemName: "iphone")
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
            Text(peerName)
                .frame(maxWidth: .infinity, alignment: .leading)
            if isPaired {
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }
        }
        .onTapGesture {
            onTap?()
        }
    }
}

#Preview {
    let peers = [
        "Test 1",
        "Test 2",
        "Test 3",
        "Test 4",
    ]
    return List(peers, id: \.self) { peer in
        JankenponPeerRow(
            peerName: peer,
            isPaired: peer == peers[1]
        ) {
            print("SELECTED PEER")
        }
    }
}
