//
//  JankenponLobbyView.swift
//  swiftui-experiment
//
//  Created by Augusto Avelino on 13/04/24.
//

import SwiftUI

enum JankenponLobbyAlert {
    case rename, invite, disconnect
}

struct JankenponLobbyView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var connection: JankenponConnection
    @State private var textFieldValue: String = ""
    @State private var isPresentingAlert = false
    @State private var alertType: JankenponLobbyAlert = .rename
    @State private var isEditingDisplayName = false
    
    var body: some View {
        HStack {
            List {
                Section {
                    JankenponTextField(
                        placeholder: UIDevice.current.name,
                        text: $textFieldValue,
                        isEditing: $isEditingDisplayName
                    )
                    Toggle(isOn: $connection.isAdvertised) {
                        Text("Discoverable")
                    }
                } header: {
                    Text("Player Info")
                }
                Section {
                    if connection.peers.isEmpty {
                        VStack {
                            Text("No players nearby")
                                .foregroundStyle(.tertiary)
                        }
                    }
                    ForEach(connection.peers) { peer in
                        JankenponPeerRow(
                            peerName: peer.peerId.displayName,
                            isPaired: connection.isPeerConnected(peer.peerId)) {
                                didSelectPeer(peer)
                            }
                    }
                } header: {
                    Text("Other Players")
                }
            }
            .navigationTitle("Lobby")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(isEditingDisplayName ? "Cancel" : "Edit") {
                        if isEditingDisplayName {
                            textFieldValue = connection.displayName
                        }
                        isEditingDisplayName.toggle()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if isEditingDisplayName {
                        Button("Save") {
                            alertType = .rename
                            isPresentingAlert = true
                        }
                    } else {
                        Button("Close") {
                            isEditingDisplayName = false
                            dismiss()
                        }
                    }
                }
            }
            .alert(isPresented: $isPresentingAlert) {
                if alertType == .rename {
                    let alertMessage = textFieldValue.isEmpty ?
                    Text("Restore Display Name to default value (\(UIDevice.current.name))?") :
                    Text("Your device will appear as \(textFieldValue), do you confirm?")
                    return Alert(
                        title: Text("Saving Display Name"),
                        message: alertMessage,
                        primaryButton: .default(Text("Confirm"), action: {
                            connection.setDisplayName(textFieldValue)
                            isEditingDisplayName = false
                        }),
                        secondaryButton: .cancel()
                    )
                } else if alertType == .disconnect {
                    return Alert(
                        title: Text("Disconnecting"),
                        message: Text("Are you sure you want to proceed?"),
                        primaryButton: .destructive(Text("Disconnect"), action: {
                            connection.disconnect()
                        }),
                        secondaryButton: .cancel()
                    )
                } else {
                    switch connection.invitationState {
                    case .received(let peerID, _):
                        return Alert(
                            title: Text("Match Invitation"),
                            message: Text("\(peerID.displayName) wants to play, do you accept?"),
                            primaryButton: .default(Text("Accept").foregroundStyle(.green), action: {
                                connection.acceptInvitation()
                            }),
                            secondaryButton: .destructive(Text("Reject")) {
                                connection.rejectInvitation()
                            }
                        )
                    default:
                        return Alert(
                            title: Text("Error"),
                            message: Text("An unknown error has occured!"),
                            dismissButton: .default(Text("Close"), action: {})
                        )
                    }
                }
            }
            .onAppear() {
                textFieldValue = connection.displayName
                connection.startBrowsing()
            }
            .onDisappear() {
                connection.stopBrowsing()
            }
            .onChange(of: connection.receivedInvite) {
                if connection.receivedInvite {
                    alertType = .invite
                    isPresentingAlert = true
                }
            }
        }
    }
    
    private func didSelectPeer(_ peer: PeerDevice) {
        if connection.isPeerConnected(peer.peerId) {
            alertType = .disconnect
            isPresentingAlert = true
        } else {
            connection.invitePeer(peer)
        }
    }
}

#Preview {
    NavigationStack {
        JankenponLobbyView()
            .environmentObject(JankenponConnection())
    }
}
