//
//  famouseCollectionViewCell.swift
//  Stock Market India
//
//  Created by Junaid Mukadam on 31/05/21.
//

import UIKit

class famouseCollectionViewCell:UICollectionViewCell{
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var taregt: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var source: UIButton!
    
    
    @IBOutlet weak var outerContainer: UIView!{
        didSet{
            outerContainer.layer.cornerRadius = 8
            outerContainer.shadow2()
        }
    }
    
}
