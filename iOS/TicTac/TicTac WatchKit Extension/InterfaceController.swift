//
//  InterfaceController.swift
//  TicTac WatchKit Extension
//
//  Created by Vigneshuvi on 20/03/17.
//  Copyright © 2017 vigneshuvi. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController,WCSessionDelegate{

    var counter = 0
    @IBOutlet var counterLabel: WKInterfaceLabel!

    @IBOutlet var startGame: WKInterfaceButton!
    var session : WCSession!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        counter = 0
        if (WCSession.isSupported()) {
            session = WCSession.default()
            session.delegate = self
            session.activate()
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func incrementCounter() {
        counter += 1
        setCounterLabelText()
    }
    
    @IBAction func clearCounter() {
        counter = 1
        setCounterLabelText()
    }
    
    @IBAction func saveCounter() {
       
    }
    
    func setCounterLabelText() {
        counterLabel.setText(String(counter))
    }

    
    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(watchOS 2.2, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //code
        switch activationState {
        case WCSessionActivationState.activated:
            NSLog("WCSessionActivationState.activated");
            
        case WCSessionActivationState.inactive:
            NSLog("WCSessionActivationState.inactive");
            
        case WCSessionActivationState.notActivated:
            NSLog("WCSessionActivationState.notActivated");
        }
        
    }
    /** ------------------------- Interactive Messaging ------------------------- */
    
    /** Called when the reachable state of the counterpart app changes. The receiver should check the reachable property on receiving this delegate callback. */
    @available(watchOS 2.0, *)
    public func sessionReachabilityDidChange(_ session: WCSession) {
        
    }
    
    
    /** Called on the delegate of the receiver. Will be called on startup if the incoming message caused the receiver to launch. */
    @available(watchOS 2.0, *)
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        let receiveMessage = message["PlayerMessage"] as? String
        if (receiveMessage == "play") {
            
            
        }
    }
    
    
    /** Called on the delegate of the receiver when the sender sends a message that expects a reply. Will be called on startup if the incoming message caused the receiver to launch. */
    @available(watchOS 2.0, *)
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Swift.Void) {
        let receiveMessage = message["PlayerMessage"] as? String
        if (receiveMessage == "play") {

        }
        
    }
    
}
