import UIKit
import Flutter
import MultipeerConnectivity

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("test")
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("test")
         DispatchQueue.main.async { [unowned self] in
        let message = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)! as String
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
         print("test")
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
         print("test")
    }
    
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var messageToSend: String!
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let CHANNEL = FlutterMethodChannel(name: "be.xavierallen.chatty/multipeerConnectivity", binaryMessenger: controller.binaryMessenger)
    
    CHANNEL.setMethodCallHandler{ [unowned self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
        if call.method == "CreatePeer"
        {
            let userNickName = call.arguments as! String
           peerID = MCPeerID(displayName: userNickName)
            mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
            mcSession.delegate = self
            print(peerID)
            
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
//              let mcBrowser = MCBrowserViewController(serviceType: "ioscreator-chat", session: mcSession)
//              mcBrowser.delegate = self
//              present(mcBrowser, animated: true)
            result("join")
            
        }
        
        if call.method == "sendMessageIOS"
        {
            let messageToSend = "TESTING"
            let message = messageToSend.data(using: String.Encoding.utf8, allowLossyConversion: false)
//
//            do {
//
//            }
//            catch {
//              print("Error sending message")
//            }
            result(messageToSend)
            
        }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
