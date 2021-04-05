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
        subcriptionRate.text = "Subcription Rate: " + String(data?.retailSubscriptionRate ?? 00)
        price.text = "Price: ₹" + String(data?.minPrice ?? 0) + " - ₹" + String(data?.maxPrice ?? 0)
        size.text = "Lot Size: " + String(data?.lotSize ?? 00)
        endDate.text = "End Date: " + (data?.biddingEndDate ?? "")
        star.starCount = startRating(rate: data?.retailSubscriptionRate ?? 10)
        
    }
    
    
    func startRating(rate:Float) -> Int {
        if rate > 100{
            
            return 5
        }else if rate > 70 {
            
            return 4
        }else if rate > 40 {
            return 3
            
        }else if rate > 5 {
            
            return 2
        }else {
            return 1
        }
    }
}
