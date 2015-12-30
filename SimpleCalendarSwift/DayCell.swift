//
//  DayCell.swift
//  SimpleCalendarSwift
//
//  Created by Y.T. Hoshino on 2015/12/30.
//  Copyright © 2015年 Yuta Hoshino. All rights reserved.
//

import UIKit
class DayCell: UICollectionViewCell {
    @IBOutlet var label: UILabel!
    
    override func awakeFromNib() {
       super.awakeFromNib()
        backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
    }
}
