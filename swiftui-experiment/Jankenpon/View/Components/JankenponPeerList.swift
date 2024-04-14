//
//  JankenponPeerList.swift
//  swiftui-experiment
//
//  Created by Augusto Avelino on 13/04/24.
//

import SwiftUI

struct JankenponPeerList: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var connection: JankenponConnection
    
    var body: some View {
        List {
            Toggle(isOn: $connection.isAdvertised) {
                Text("Discoverable")
            }
            Section {
                ForEach(connection.peers) { peer in
                    Text(peer.peerId.displayName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.clear)
                        .onTapGesture {
                            if connection.opponent != peer {
                                connection.opponent = peer
                            } else {
                                connection.opponent = nil
                            }
                        }
                }
            } header: {
                Text("Devices")
            }
        }
        .toolbar {
            Button(action: { dismiss() }) {
                Text("Close")
            }
        }
        .onAppear() {
            connection.startBrowsing()
        }
        .onDisappear() {
            connection.stopBrowsing()
        }
    }
}

#Preview {
    JankenponPeerList()
        .environmentObject(JankenponConnection())
}
