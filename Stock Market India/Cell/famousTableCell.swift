//
//  famousTableCell.swift
//  Stock Market India
//
//  Created by Junaid Mukadam on 31/05/21.
//

import UIKit
import SafariServices

class famousTableCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        inflModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "famouseCollectionViewCell", for: indexPath) as! famouseCollectionViewCell
        
        cell.name.text = inflModel[indexPath.row].StockName
        cell.taregt.text = "Target: ₹" + inflModel[indexPath.row].Target
        cell.date.text = "Posted: " + inflModel[indexPath.row].Date
        cell.source.setTitle(inflModel[indexPath.row].Source, for: .normal)
        cell.source.tag = indexPath.row
        cell.source.addTarget(self, action: #selector(sourceTapped), for: .touchUpInside)
        cell.newLabel.isHidden = isInfluentialstockNew(id: inflModel[indexPath.row].id)
        
        return cell
    }
    
    @objc func sourceTapped(sender:UIButton){
        
        if let url = URL(string: inflModel[sender.tag].SourceLink) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            
            if let topController = UIApplication.topViewController() {
               topController.present(vc, animated: true)
            }
           
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width:CGFloat = (collectionView.frame.size.width)
        let height:CGFloat = (collectionView.frame.size.height)
        return CGSize(width: width, height: height)
    }
    
    
    
    @IBOutlet weak var myView: UICollectionView!
    
    var inflModel = [InfluentialModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        postWithParameter(Url: "Influential.php", parameters: [:]) { JSON, Err in
            
            for (_,Subjson) in JSON {
                
                self.inflModel.append(InfluentialModel(StockName: Subjson["Stock Name"].string ?? " ", Target: Subjson["Target"].string ?? " ", Date: Subjson["Date"].string ?? " ", Source: Subjson["Source"].string ?? " ", SourceLink: Subjson["Source Link"].string ?? " ", id: Subjson["id"].string ?? " "))
            }
            
            self.myView.delegate = self
            self.myView.dataSource = self
            self.myView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if self.inflModel.count > 2 {
                    let indexPath = IndexPath(item: 1, section: 0)
                    self.myView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func isInfluentialstockNew(id:String) -> Bool {
        
        let addedTimemili = Double(id)
        let hourToaddMili:Double = 110000000 // 30 Hours in Mili
        let currentTimemili:Double = Date().timeIntervalSince1970 * 1000
        
        let totalNewtime = (addedTimemili ?? 000) + hourToaddMili
        
        return totalNewtime < currentTimemili
    }
    
}


class InfluentialModel {
    var id = ""
    var StockName = ""
    var Target = ""
    var Date = ""
    var Source = ""
    var SourceLink = ""
    
    init(StockName:String,Target:String,Date:String,Source:String,SourceLink:String,id:String) {
        self.id = id
        self.StockName = StockName
        self.Target = Target
        self.Date = Date
        self.Source = Source
        self.SourceLink = SourceLink
    }
}


extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
