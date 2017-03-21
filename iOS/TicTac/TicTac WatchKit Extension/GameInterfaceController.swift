//
//  GameInterfaceController.swift
//  TicTac
//
//  Created by Vigneshuvi on 21/03/17.
//  Copyright © 2017 vigneshuvi. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class GameInterfaceController: WKInterfaceController,WCSessionDelegate {


    var dataSource = [TicTacToeModel]()
    var session : WCSession!
    var isReceiveMessage : Bool = false
    @IBOutlet var gridButton00: WKInterfaceButton!
    @IBOutlet var gridButton01: WKInterfaceButton!
    @IBOutlet var gridButton02: WKInterfaceButton!
    
    @IBOutlet var gridButton10: WKInterfaceButton!
    @IBOutlet var gridButton11: WKInterfaceButton!
    @IBOutlet var gridButton12: WKInterfaceButton!
    
    @IBOutlet var gridButton20: WKInterfaceButton!
    @IBOutlet var gridButton21: WKInterfaceButton!
    @IBOutlet var gridButton22: WKInterfaceButton!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        if (WCSession.isSupported()) {
            session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        self.restart()
    }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func gridButton00Action() {
        print("=== gridButton00Action ===");
        self.sendMessage(message: "00", row: 0, column: 0)
    }
    
    @IBAction func gridButton01Action() {
        print("=== gridButton01Action ===");
        self.sendMessage(message: "01", row: 0, column: 1)
    }
    
    @IBAction func gridButton02Action() {
        print("=== gridButton02Action ===");
        self.sendMessage(message: "02", row: 0, column: 2)
    }
    
    
    @IBAction func gridButton10Action() {
        print("=== gridButton10Action ===");
        self.sendMessage(message: "10", row: 1, column: 0)
    }
    
    @IBAction func gridButton11Action() {
        print("=== gridButton11Action ===");
        self.sendMessage(message: "11", row: 1, column: 1)
    }
    
    @IBAction func gridButton12Action() {
        print("=== gridButton12Action ===");
        self.sendMessage(message: "12", row: 1, column: 2)
    }
    
    
    @IBAction func gridButton20Action() {
        print("=== gridButton20Action ===");
        self.sendMessage(message: "20", row: 2, column: 0)
    }
    
    @IBAction func gridButton21Action() {
        print("=== gridButton21Action ===");
        self.sendMessage(message: "21", row: 2, column: 1)
    }
    
    @IBAction func gridButton22Action() {
        print("=== gridButton22Action ===");
        self.sendMessage(message: "22", row: 2, column: 2)
    }


    @IBAction func restart() {
        self.enableButtons(isEnable: true);
        self.isReceiveMessage = false;
        if(self.dataSource.count > 0) {
            self.dataSource.removeAll();
        }

        let requestValues = ["PlayerMessage" :  "restart", "row" : -1, "column": -1] as [String : Any]

        if !session.isReachable {
            //  get default session
            session = WCSession.default()
            //  set delegate
            session!.delegate = self
            //  activate session
            session!.activate()
        }
        
        if (session.isReachable) {
            session.sendMessage(requestValues, replyHandler: nil, errorHandler:nil)
        }
    }
    
    func enableButtons(isEnable : Bool) {
        self.gridButton00.setEnabled(isEnable)
        self.gridButton00.setBackgroundColor(UIColor.cyan)
        
        self.gridButton01.setEnabled(isEnable)
        self.gridButton01.setBackgroundColor(UIColor.cyan)
        
        self.gridButton02.setEnabled(isEnable)
        self.gridButton02.setBackgroundColor(UIColor.cyan)
        
        self.gridButton10.setEnabled(isEnable)
        self.gridButton10.setBackgroundColor(UIColor.cyan)
        
        self.gridButton11.setEnabled(isEnable)
        self.gridButton11.setBackgroundColor(UIColor.cyan)
        
        self.gridButton12.setEnabled(isEnable)
        self.gridButton12.setBackgroundColor(UIColor.cyan)
        
        self.gridButton20.setEnabled(isEnable)
        self.gridButton20.setBackgroundColor(UIColor.cyan)
        
        self.gridButton21.setEnabled(isEnable)
        self.gridButton21.setBackgroundColor(UIColor.cyan)
        
        self.gridButton22.setEnabled(isEnable)
        self.gridButton22.setBackgroundColor(UIColor.cyan)
    }
    
    func sendMessage(message: String, row: Int, column: Int) {
        if(!self.isReceiveMessage) {
            if message ==  "play"{
                self.enableButtons(isEnable: true);
                self.isReceiveMessage = false;
                if(self.dataSource.count > 0) {
                    self.dataSource.removeAll();
                }
            } else if message ==  "restart" {
                self.enableButtons(isEnable: true);
                self.isReceiveMessage = false;
                if(self.dataSource.count > 0) {
                    self.dataSource.removeAll();
                }
            } else {
                self.isReceiveMessage = true;
                var obj: TicTacToeModel =  TicTacToeModel()
                if let index = self.dataSource.index(where: { $0.position == message }) {
                    //Do Something
                    obj = self.dataSource[index]
                    if obj.position.characters.count > 0 {
                        obj = TicTacToeModel();
                        obj.row = row
                        obj.column = column
                    }
                    obj.position = message;
                    obj.isSelected = true;
                    obj.userType = 2;
                    self.dataSource.remove(at: index)
                    self.dataSource.insert(obj, at: index)
                } else {
                    obj.position = message;
                    obj.isSelected = true;
                    obj.userType = 2;
                    self.dataSource.append(obj)
                    
                }
                self.enableButton(message: message, enable: false)
            }
            let requestValues = ["PlayerMessage" : message, "row" : row, "column":column] as [String : Any]
            session.sendMessage(requestValues, replyHandler: nil, errorHandler:nil)
            self.findWhoisWinner();
        }
    }
    
    func enableButton(message: String, enable : Bool) {
        var Button: WKInterfaceButton? = nil ;
        switch message {
        case "00":
            self.gridButton00.setEnabled(enable)
            Button = self.gridButton00;
            break
        case "01":
            self.gridButton01.setEnabled(enable)
             Button = self.gridButton01;
            break
        case "02":
            self.gridButton02.setEnabled(enable)
             Button = self.gridButton02;
            break
        case "10":
            self.gridButton10.setEnabled(enable)
             Button = self.gridButton10;
            break
        case "11":
            self.gridButton11.setEnabled(enable)
             Button = self.gridButton11;
            break
        case "12":
            self.gridButton12.setEnabled(enable)
             Button = self.gridButton12;
            break
        case "20":
            self.gridButton20.setEnabled(enable)
             Button = self.gridButton20;
            break
        case "21":
            self.gridButton21.setEnabled(enable)
             Button = self.gridButton21;
            break
        case "22":
            self.gridButton22.setEnabled(enable)
            Button = self.gridButton22;
            break
        default :
            print("default selected!!")
        }
        if Button != nil {
            self.changeButtonPropery(message:message , button: Button!)
        }
    }
    
    func changeButtonPropery (message: String, button: WKInterfaceButton) {
        if let index = self.dataSource.index(where: { $0.position == message }) {
            //Do Something
            let obj = self.dataSource[index]
            if(obj.isSelected) {
                if  obj.userType == 1 {
                    button.setBackgroundColor(UIColor.green)
                } else {
                    button.setBackgroundColor (UIColor.blue)
                }
                // make cell more visible in our example project
            } else {
                button.setBackgroundColor(UIColor.cyan)// make cell more visible in our example project
            }
        } else {
            button.setBackgroundColor(UIColor.cyan)
        }
        
    }
    
    func findWhoisWinner() {
        if  self.dataSource.count > 0 {
            let user1Predicate:NSPredicate = NSPredicate(format: "userType = %d", 1);
            let user1Array:NSArray = (self.dataSource as NSArray).filtered(using: user1Predicate) as NSArray
            if user1Array.count > 2 {
                print("User Type count \(user1Array.count)")
            }
            
            let user2Predicate:NSPredicate = NSPredicate(format: "userType = %d", 2);
            let user2Array:NSArray = (self.dataSource as NSArray).filtered(using: user2Predicate) as NSArray
            if user2Array.count > 2 {
                print("User Type count \(user2Array.count)")
            }
        }
    }
    
    func receiveMessage(message: String, row: Int, column: Int)  {
        if row > -1 && column > -1 {
            var obj: TicTacToeModel =  TicTacToeModel()
            if let index = self.dataSource.index(where: { $0.position == message }) {
                //Do Something
                obj = self.dataSource[index]
                if obj.position.characters.count > 0 {
                    obj = TicTacToeModel();
                }
                obj.position = message;
                obj.isSelected = true;
                obj.userType = 1;
                obj.row = row;
                obj.column = column;
                self.dataSource.remove(at: index)
                self.dataSource.insert(obj, at: index)
            } else {
                obj.position = message;
                obj.isSelected = true;
                obj.userType = 1;
                obj.row = row;
                obj.column = column;
                self.dataSource.append(obj)
            }
            self.enableButton(message: message, enable: false)
        }
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
        
        if let receiveMessage = message["PlayerMessage"] as? String , let row = message["row"] as? Int, let column = message["column"] as? Int{
            self.receiveMessageHandler(message: receiveMessage, row: row, column: column)
        }
    }
    
    
    /** Called on the delegate of the receiver when the sender sends a message that expects a reply. Will be called on startup if the incoming message caused the receiver to launch. */
    @available(watchOS 2.0, *)
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Swift.Void) {
        if let receiveMessage = message["PlayerMessage"] as? String , let row = message["row"] as? Int, let column = message["column"] as? Int{
            self.receiveMessageHandler(message: receiveMessage, row: row, column: column)
        }
    }
    
    // Receive Message Handler
    func receiveMessageHandler(message :String, row: Int, column: Int) {
        if (message == "won") {
            let act:WKAlertAction = WKAlertAction(title: "OK", style: WKAlertActionStyle.cancel, handler:{
                self.enableButtons(isEnable: true);
                self.isReceiveMessage = false;
                if(self.dataSource.count > 0) {
                    self.dataSource.removeAll();
                }
            });
            self.presentAlert(withTitle: "Hey", message: "\(row == 1 ? "iPhone" : "iWatch" ) is won the match!!!", preferredStyle: WKAlertControllerStyle.alert, actions: [act])
        } else if (message == "restart") {
            self.enableButtons(isEnable: true);
            self.isReceiveMessage = false;
            if(self.dataSource.count > 0) {
                self.dataSource.removeAll();
            }
        } else if (message == "play") {
            self.enableButtons(isEnable: true);
            self.isReceiveMessage = false;
            if(self.dataSource.count > 0) {
                self.dataSource.removeAll();
            }
        } else if(self.isReceiveMessage) {
            self.isReceiveMessage = false;
            self.receiveMessage(message: message, row: row, column: column)
        }
    }
}
