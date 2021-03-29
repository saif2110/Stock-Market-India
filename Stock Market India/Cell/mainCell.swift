//
//  main.swift
//  Stock Market India
//
//  Created by Junaid Mukadam on 09/12/20.
//

import UIKit
import GoogleMobileAds

class mainCell: UITableViewCell {

    @IBOutlet weak var OutsideView: UIView!
    
    @IBOutlet weak var nameStock: UILabel!
    
    @IBOutlet weak var Date: UILabel!
    
    @IBOutlet weak var CurrentPrice: UILabel!
    
    @IBOutlet weak var SellTarget: UILabel!
    
    @IBOutlet weak var Period: UILabel!
    
    @IBOutlet weak var StopLoss: UILabel!
    
    @IBOutlet weak var Like: UIButton!
    
    @IBOutlet weak var DisLike: UIButton!
    
    @IBOutlet weak var adView: GADBannerView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        OutsideView.layer.cornerRadius = 10
        adView?.layer.cornerRadius = 10
        adView?.backgroundColor = .white
        adView?.adUnitID = "ca-app-pub-2710347124980493/2705217445"
        OutsideView.shadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
