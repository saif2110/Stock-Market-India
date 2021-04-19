//
//  IPOopen.swift
//  Stock Market India
//
//  Created by Junaid Mukadam on 29/03/21.
//

import UIKit
import StarReview
import Kingfisher

class IPOopen: UITableViewCell {
    @IBOutlet weak var outerBox: UIView!
    
    @IBOutlet weak var star: StarReview!
    var data:DataOFjson?
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var subcriptionRate: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var ViewInfo: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        star.isUserInteractionEnabled = false
        star.value = 0
        star.starCount = 5
        star.allowAccruteStars = false
        star.allowEdit = false
        star.starBackgroundColor = .systemOrange
        star.starFillColor = .clear
        outerBox.layer.cornerRadius = 8
        outerBox.shadow2()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        logo.kf.setImage(with: URL(string: data?.logoUrl ?? ""))
        name.text = data?.name
        subcriptionRate.text = "Issue Size: ₹" + String(data?.issueSize ?? "Coming Soon") + " Cr"
        price.text = "Price: ₹" + String(data?.minPrice ?? "Coming Soon") + " - ₹" + String(data?.maxPrice ?? "Coming Soon")
        size.text = "Lot Size: " + String(data?.lotSize ?? "Coming Soon")
        endDate.text = "End Date: " + (data?.biddingEndDate ?? "Coming Soon")
        star.starCount = Int(data?.stars ?? "2") ?? 2
        
    }
    
    
}
