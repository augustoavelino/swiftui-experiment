//
//  JankenponConnection.swift
//  swiftui-experiment
//
//  Created by Augusto Avelino on 13/04/24.
//

import MultipeerConnectivity
import SwiftUI

class JankenponConnection: NSObject, ObservableObject {
    @AppStorage("display-name") private(set) var displayName: String = ""
    
    private let serviceType = "jkp-match-svc"
    
    private var advertiser: MCNearbyServiceAdvertiser
    private var browser: MCNearbyServiceBrowser
    private var session: MCSession
    
    @Published var isAdvertised: Bool = false {
        didSet {
            isAdvertised ? advertiser.startAdvertisingPeer() : advertiser.stopAdvertisingPeer()
        }
    }
    
    @Published var peers: [PeerDevice] = []
    @Published var receivedInvite = false
    private(set) var invitationState: InvitationState = .idle
    private var invitationHandler: ((Bool, MCSession?) -> Void)?
    
    override init() {
        let peer = Self.getCurrentID()
        session = MCSession(peer: peer)
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: serviceType)
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceType)
        super.init()
        advertiser.delegate = self
        browser.delegate = self
    }
    
    func setDisplayName(_ displayName: String) {
        self.displayName = displayName
        reloadCurrentPeer()
    }
    
    func startBrowsing() {
        browser.startBrowsingForPeers()
    }
    
    func stopBrowsing() {
        browser.stopBrowsingForPeers()
        peers.removeAll()
    }
    
    func invitePeer(_ peer: PeerDevice) {
        print("INVITING \(peer.peerId)")
        browser.invitePeer(peer.peerId, to: session, withContext: nil, timeout: 60.0)
    }
    
    private func reloadCurrentPeer() {
        invalidateCurrentPeer()
        let peer = Self.getCurrentID()
        session = MCSession(peer: peer)
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: serviceType)
        advertiser.delegate = self
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceType)
        browser.delegate = self
        startBrowsing()
        if isAdvertised {
            advertiser.startAdvertisingPeer()
        }
    }
    
    private func invalidateCurrentPeer() {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
        session.disconnect()
        peers.removeAll()
    }
    
    private static func getCurrentID() -> MCPeerID {
        if let storedDisplayName = UserDefaults.standard.string(forKey: "display-name"), 
            !storedDisplayName.isEmpty {
            MCPeerID(displayName: storedDisplayName)
        } else {
            MCPeerID(displayName: UIDevice.current.name)
        }
    }
    
    func acceptInvitation() {
        invitationHandler?(true, session)
        invitationState = .idle
    }
    
    func rejectInvitation() {
        invitationHandler?(false, session)
        invitationState = .idle
    }
}

// MARK: - MCSessionDelegate

extension JankenponConnection: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("")
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let stringData = String(data: data, encoding: .utf8) {
            print("Received \(stringData) from \(peerID.displayName)")
        } else {
            print("Received non-string data from \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {}
}

// MARK: - MCNearbyServiceBrowserDelegate

extension JankenponConnection: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        peers.append(PeerDevice(peerId: peerID))
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        peers.removeAll(where: { $0.peerId == peerID })
    }
}

// MARK: - MCNearbyServiceAdvertiserDelegate

extension JankenponConnection: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        DispatchQueue.main.async {
            if self.invitationState == .idle {
                self.receivedInvite = true
                self.invitationState = .received(peerID: peerID, context: context)
                self.invitationHandler = invitationHandler
            }
        }
    }
}

// MARK: - PeerDevice

struct PeerDevice: Identifiable, Hashable {
    let id = UUID()
    let peerId: MCPeerID
}

// MARK: -

enum InvitationState: Equatable {
    case inviting(peerId: MCPeerID)
    case received(peerID: MCPeerID, context: Data?)
    case idle
}
