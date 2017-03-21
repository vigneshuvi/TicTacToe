//
//  HomeInterfaceController.swift
//  TicTac
//
//  Created by Vigneshuvi on 20/03/17.
//  Copyright © 2017 vigneshuvi. All rights reserved.
//

import WatchKit
import Foundation


class HomeInterfaceController: WKInterfaceController {
    @IBOutlet var tableView: WKInterfaceTable!
    var names = ["Matthew", "Mark", "Luke", "John"]
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    
        // Configure interface objects here.
        names = ["Matthew", "Mark", "Luke", "John"]

  
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        tableRefresh()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func tableRefresh(){
        tableView.setNumberOfRows(names.count, withRowType: "TicTacToeWatchCell")
        for (index, name) in names.enumerated() {
            let row = tableView.rowController(at: index) as! TicTacToeWatchCell
            row.titleLabel.setText(name)
        }
    }
    
    //table selection method
    
    func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        //build a context for the data
         print("You selected rowIndex #\(rowIndex)!")
    }

    

}
