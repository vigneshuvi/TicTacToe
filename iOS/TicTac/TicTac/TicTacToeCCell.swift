//
//  TicTacToeCell.swift
//  TicTac
//
//  Created by Vigneshuvi on 20/03/17.
//  Copyright © 2017 vigneshuvi. All rights reserved.
//

import UIKit

class TicTacToeCCell: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    
    var text: String = "" {
        willSet {
            self.titleLabel.text = newValue
        }
    }

}
