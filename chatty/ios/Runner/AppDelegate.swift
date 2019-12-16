import UIKit
import Flutter
import MultipeerConnectivity

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var messageFromPeer: String!
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
       switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")

        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")

        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
         DispatchQueue.main.async { [unowned self] in
        let message = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)! as String
            print(message)
            self.messageFromPeer = message
            
            let alert = UIAlertController(title: "New message", message: message, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

             self.window?.rootViewController?.present(alert, animated: true)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
         print("test")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
         print("test")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
         print("test")
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        self.window?.rootViewController?.dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        self.window?.rootViewController?.dismiss(animated: true)
    }
    
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var messageToSend: String!
    var serviceAdvertiser: MCNearbyServiceAdvertiser!
    var serviceBrowser: MCNearbyServiceBrowser!
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let CHANNEL = FlutterMethodChannel(name: "be.xavierallen.chatty/multipeerConnectivity", binaryMessenger: controller.binaryMessenger)
    
    CHANNEL.setMethodCallHandler{ [unowned self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
        
        if call.method == "CreatePeer"
        {
            let userNickName = call.arguments as! String
            peerID = MCPeerID(displayName: userNickName)
            mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
            mcSession.delegate = self
//            print(peerID)
            
            result(userNickName)
        }
        
        if call.method == "hostSession"
        {
            mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "ioscreator-chat", discoveryInfo: nil, session: mcSession)
            mcAdvertiserAssistant.start()
            result("host")
            
        }
        
        if call.method == "joinSession"
        {
            
            let mcBrowser = MCBrowserViewController(serviceType: "ioscreator-chat", session: mcSession)
            mcBrowser.delegate = self
            self.window?.rootViewController?.present(mcBrowser, animated: true)
            result("join")
            
        }
        
        if call.method == "sendMessageIOS"
        {
            let messageFromFlutter = call.arguments as! String
            let message = messageFromFlutter.data(using: String.Encoding.utf8, allowLossyConversion: false)

            do {
                try mcSession.send(message!, toPeers: mcSession.connectedPeers, with: .unreliable)
            }
            catch {
              print("Error sending message")
            }
            
            let peers = mcSession.connectedPeers.description
            result(peers)
        }
        
        if call.method == "receiveMessageIOS"
        {
            result(self.messageFromPeer)
            
        }
        
        if call.method == "closeConnectionIOS"
        {
            mcSession.disconnect();
            let peers = mcSession.connectedPeers.description
            result(peers)
        }
        
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
