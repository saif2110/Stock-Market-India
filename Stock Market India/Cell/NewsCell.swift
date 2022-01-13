//
//  NewsCell.swift
//  Stock Market India
//
//  Created by Saif on 08/01/22.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var contanerView: UIView!{
        didSet{
            contanerView.layer.cornerRadius = 8
            contanerView.shadow2()
        }
    }
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var decription: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    var url = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
