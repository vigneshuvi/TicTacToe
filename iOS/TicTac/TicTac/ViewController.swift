//
//  ViewController.swift
//  TicTac
//
//  Created by Vigneshuvi on 20/03/17.
//  Copyright © 2017 vigneshuvi. All rights reserved.
//

import UIKit

import WatchConnectivity

class ViewController: UIViewController,WCSessionDelegate,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
    var dataSource = [TicTacToeModel]()
    var session: WCSession!
    var isReceiveMessage : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.collectionView.register(TicTacToeCCell.self, forCellWithReuseIdentifier: "TicTacToeCell");
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.reloadDataSource();
        if (WCSession.isSupported()) {
            let session = WCSession.default();
            session.delegate = self;
            session.activate()
            NSLog("WCSession is supported");
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playAction(_ sender: Any) {
        //  get default session
        self.session = WCSession.default()
        //  set delegate
        self.session!.delegate = self
        if !self.session.isReachable {
            self.session!.activate()
        }
        
        
        if (WCSession.default().isReachable && WCSession.isSupported()) {
            // Do something
            let requestValues = ["PlayerMessage" :  "play", "row" : -1, "column": -1] as [String : Any]
            self.session.sendMessage(requestValues, replyHandler: { (replayDic: [String : Any]) in
                print(replayDic["PlayerMessage"] as Any)
                
            }, errorHandler: { (error: Error) in
                print(error.localizedDescription)
            })
            self.reloadDataSource();
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        
        //  get default session
        self.session = WCSession.default()
        //  set delegate
        self.session!.delegate = self
        if !self.session.isReachable {
            self.session!.activate()
        }
        
        
        if (WCSession.default().isReachable && WCSession.isSupported()) {
            // Do something
            let requestValues = ["PlayerMessage" :  "restart", "row" : -1, "column": -1] as [String : Any]
            self.session.sendMessage(requestValues, replyHandler: { (replayDic: [String : Any]) in
                print(replayDic["PlayerMessage"] as Any)
                
            }, errorHandler: { (error: Error) in
                print(error.localizedDescription)
            })
            self.reloadDataSource();
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }
    
    func sentWinningMessage(type:Int) {
        //  get default session
        self.session = WCSession.default()
        //  set delegate
        self.session!.delegate = self
        if !self.session.isReachable {
            //  activate session
            self.session!.activate()
        }
        
        if (WCSession.default().isReachable && WCSession.isSupported()) {
            // Do something
            let requestValues = ["PlayerMessage" :  "won", "row" : type, "column": -1] as [String : Any]
            
            self.session.sendMessage(requestValues, replyHandler: { (replayDic: [String : Any]) in
                print(replayDic["PlayerMessage"] as Any)
            }, errorHandler: { (error: Error) in
                print(error.localizedDescription)
            })
            let alertController = UIAlertController(title: "Hey!!", message: "\(type == 1 ? "iPhone" : "iWatch" ) is won the match!!!", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler:  { action in
                // perhaps use action.title here
                DispatchQueue.main.async {
                    self.reloadDataSource();
                    self.collectionView.reloadData()
                }
            })
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    
    func reloadDataSource() {
        if(self.dataSource.count > 0) {
            self.dataSource.removeAll();
        }
        self.isReceiveMessage = false;
        
        for i in 0 ..< 3 {
            for j in 0 ..< 3 {
                let obj:TicTacToeModel = TicTacToeModel();
                obj.position = "\(i)\(j)";
                obj.isSelected = false;
                obj.userType = -1;
                obj.row = i
                obj.column = j
                self.dataSource.append(obj)
            }
            
        }
    }
    
    func findWhoisWinner() {
        if  self.dataSource.count > 4 {
            let sortArray = self.dataSource.sorted {
                return Int($0.position)! < Int($1.position)!
            }
            let user1Array = sortArray.filter { $0.userType == 1 }
            let user2Array = sortArray.filter { $0.userType == 2 }
            
            if user1Array.count > 2 {
                self.detectBasedonRowType(userArray: user1Array, with:1)
            }
            
            if user2Array.count > 2 {
                self.detectBasedonRowType(userArray: user2Array, with:2)
            }
        }
    }

    
    // Sort based on user type
    func detectBasedonRowType(userArray: [TicTacToeModel], with type:Int) {
        let row1Array = userArray.filter { $0.row == 0 }
        let row2Array = userArray.filter { $0.row == 1 }
        let row3Array = userArray.filter { $0.row == 2 }
        if row1Array.count > 2 {
            self.detectArray(userArray: row1Array, with:type, isRow:true);
        } else if row2Array.count > 2 {
            self.detectArray(userArray: row2Array, with:type, isRow:true);
        } else if row3Array.count > 2 {
            self.detectArray(userArray: row3Array, with:type, isRow:true);
        } else {
            var leftToptoBottom : Int = 0;
            var bottomRighttoTop : Int = 0;
            for i in 0 ..< userArray.count-1 {
                let obj1 :TicTacToeModel = userArray[i];
                let obj2 :TicTacToeModel = userArray[i+1];
                if obj1.row < obj2.row && obj1.column > obj2.column {
                    leftToptoBottom = leftToptoBottom+1;
                }
                
                if obj1.row < obj2.row && obj1.column < obj2.column  {
                    bottomRighttoTop = bottomRighttoTop+1;
                }
            }
            if(leftToptoBottom == 2 || bottomRighttoTop  == 2) {
               
                self.sentWinningMessage(type: type)
            } else {
                self.detectBasedonColumnType(userArray: userArray, with:type)
            }

        }
    }
    
    
    func detectBasedonColumnType(userArray: [TicTacToeModel], with type:Int) {
        let c1Array = userArray.filter { $0.column == 0 }
        let c2Array = userArray.filter { $0.column == 1 }
        let c3Array = userArray.filter { $0.column == 2 }
        if c1Array.count > 2 {
            self.detectArray(userArray: c1Array, with:type, isRow:false);
        } else if c2Array.count > 2 {
            self.detectArray(userArray: c2Array, with:type, isRow:false);
        } else if c3Array.count > 2 {
            self.detectArray(userArray: c3Array, with:type, isRow:false);
        } else {
            var leftToptoBottom : Int = 0;
            var bottomRighttoTop : Int = 0;
            for i in 0 ..< userArray.count-1 {
                let obj1 :TicTacToeModel = userArray[i];
                let obj2 :TicTacToeModel = userArray[i+1];
                if obj1.row < obj2.row && obj1.column > obj2.column {
                    leftToptoBottom = leftToptoBottom+1;
                }
                
                if obj1.row < obj2.row && obj1.column < obj2.column  {
                    bottomRighttoTop = bottomRighttoTop+1;
                }
            }
            if(leftToptoBottom == 2 || bottomRighttoTop  == 2) {
                
                self.sentWinningMessage(type: type)
            }

        }
    }
    
    func detectArray(userArray: [TicTacToeModel], with type:Int, isRow:Bool) {
        if isRow {
            let c1Array = userArray.filter { $0.column == 0 }
            let c2Array = userArray.filter { $0.column == 1 }
            let c3Array = userArray.filter { $0.column == 2 }
            if c1Array.count == 1 && c2Array.count == 1 && c3Array.count == 1 {
                 self.sentWinningMessage(type: type)
            } else {
                var foundWinner : Int = 0;
                for i in 0 ..< userArray.count-1 {
                    let obj1 :TicTacToeModel = userArray[i];
                    let obj2 :TicTacToeModel = userArray[i+1];
                    if obj1.column > obj2.column {
                        foundWinner = foundWinner+1;
                    }
                }
                if(foundWinner == 2) {
                     self.sentWinningMessage(type: type)
                }
                
            }
        } else {
            let r1Array = userArray.filter { $0.row == 0 }
            let r2Array = userArray.filter { $0.row == 1 }
            let r3Array = userArray.filter { $0.row == 2 }
            if r1Array.count == 1 && r2Array.count == 1 && r3Array.count == 1 {
                 self.sentWinningMessage(type: type)
            } else {
                var foundWinner : Int = 0;
                for i in 0 ..< userArray.count-1 {
                    let obj1 :TicTacToeModel = userArray[i];
                    let obj2 :TicTacToeModel = userArray[i+1];
                    if obj1.row > obj2.row {
                        foundWinner = foundWinner+1;
                    }
                }
                if(foundWinner == 2) {
                     self.sentWinningMessage(type: type)
                }
                
            }
        }
        
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell:TicTacToeCCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TicTacToeCell", for: indexPath as IndexPath) as! TicTacToeCCell
        let obj: TicTacToeModel = self.dataSource[indexPath.row]
        if(obj.isSelected) {
            if  obj.userType == 1 {
                 cell.backgroundColor = UIColor.green
            } else {
                cell.backgroundColor = UIColor.blue
            }
                // make cell more visible in our example project
        } else {
             cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        }
       
        
        return cell
    }

    

    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        if(self.isReceiveMessage) {
            self.isReceiveMessage = false;
            //  get default session
            self.session = WCSession.default()
            //  set delegate
            self.session!.delegate = self
            if !self.session.isReachable {
               
                //  activate session
                self.session!.activate()
            }
            
            if (WCSession.default().isReachable && WCSession.isSupported()) {
                // Do something
                
                let obj: TicTacToeModel = self.dataSource[indexPath.row]
                if(!obj.isSelected) {
                    if(obj.userType != 1 ) {
                        obj.isSelected = true;
                        obj.userType = 1;
                    }
                    self.dataSource[indexPath.row] = obj

                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        let requestValues = ["PlayerMessage" :  obj.position, "row" : obj.row, "column": obj.column] as [String : Any]
                        self.session.sendMessage(requestValues, replyHandler: { (replayDic: [String : Any]) in
                            print(replayDic["PlayerMessage"] as Any)
                        }, errorHandler: { (error: Error) in
                            print(error.localizedDescription)
                        })
                        self.findWhoisWinner()
                    }
                }
            }
        }
    }
    
    
    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    
    
    /** ------------------------- iOS App State For Watch ------------------------ */
    
    /** Called when the session can no longer be used to modify or add any new transfers and, all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur. This will happen when the selected watch is being changed. */
    @available(iOS 9.3, *)
    public func sessionDidBecomeInactive(_ session: WCSession){
        
    }
    
    
    /** Called when all delegate callbacks for the previously selected watch has occurred. The session can be re-activated for the now selected watch using activateSession. */
    @available(iOS 9.3, *)
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    
    /** Called when any of the Watch state properties change. */
    @available(iOS 9.0, *)
    public func sessionWatchStateDidChange(_ session: WCSession) {
        
    }
    
    
    /** ------------------------- Interactive Messaging ------------------------- */
    
    /** Called when the reachable state of the counterpart app changes. The receiver should check the reachable property on receiving this delegate callback. */
    @available(iOS 9.0, *)
    public func sessionReachabilityDidChange(_ session: WCSession) {
        
    }
    
    
    /** Called on the delegate of the receiver. Will be called on startup if the incoming message caused the receiver to launch. */
    @available(iOS 9.0, *)
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]){
        if let receiveMessage = message["PlayerMessage"] as? String , let row = message["row"] as? Int, let column = message["column"] as? Int{
            self.receiveMessageHandler(message: receiveMessage, row: row, column: column)
        }
    }
    
    /** Called on the delegate of the receiver when the sender sends a message that expects a reply. Will be called on startup if the incoming message caused the receiver to launch. */
    @available(iOS 9.0, *)
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Swift.Void) {
        if let receiveMessage = message["PlayerMessage"] as? String , let row = message["row"] as? Int, let column = message["column"] as? Int{
            self.receiveMessageHandler(message: receiveMessage, row: row, column: column)
        }
    }
    
    // Receive Message Handler
    func receiveMessageHandler(message :String , row: Int, column: Int) {
        if (message == "restart") {
            self.reloadDataSource();
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }else if (message == "play") {
            self.reloadDataSource();
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } else  if(!self.isReceiveMessage) {
            //Use this to update the UI instantaneously
            DispatchQueue.main.async {
                if  let index = self.dataSource.index(where: { $0.position == message }) {
                    let obj: TicTacToeModel = self.dataSource[index]
                    self.isReceiveMessage = true;
                    obj.position = message;
                    obj.isSelected = true;
                    obj.userType = 2;
                    obj.row = row;
                    obj.column = column;
                    self.dataSource[index] = obj
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.findWhoisWinner()
                    }
                }

            }
        }
    }


}

extension ViewController : UICollectionViewDelegateFlowLayout {

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width:CGFloat = (collectionView.frame.size.width-20)/3;
        return CGSize(width: width, height: width);
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0,  0, 0)
    }
    

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

