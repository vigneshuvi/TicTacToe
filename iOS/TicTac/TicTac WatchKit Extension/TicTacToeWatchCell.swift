//
//  TicTacToeCell.swift
//  TicTac
//
//  Created by Vigneshuvi on 20/03/17.
//  Copyright © 2017 vigneshuvi. All rights reserved.
//

import WatchKit

class TicTacToeWatchCell: NSObject {
    @IBOutlet var titleLabel: WKInterfaceLabel!
    
    var text: String = "" {
        willSet {
            self.titleLabel.setText(newValue)
        }
    }
    

}

