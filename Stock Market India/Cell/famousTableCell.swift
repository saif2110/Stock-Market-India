//
//  famousTableCell.swift
//  Stock Market India
//
//  Created by Junaid Mukadam on 31/05/21.
//

import UIKit

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
        
        return cell
    }
    
    @objc func sourceTapped(sender:UIButton){
        let url = URL(string: inflModel[sender.tag].SourceLink)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
                
                self.inflModel.append(InfluentialModel(StockName: Subjson["Stock Name"].string ?? " ", Target: Subjson["Target"].string ?? " ", Date: Subjson["Date"].string ?? " ", Source: Subjson["Source"].string ?? " ", SourceLink: Subjson["Source Link"].string ?? " "))
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
    
}


class InfluentialModel {
    var StockName = ""
    var Target = ""
    var Date = ""
    var Source = ""
    var SourceLink = ""
    
    init(StockName:String,Target:String,Date:String,Source:String,SourceLink:String) {
        self.StockName = StockName
        self.Target = Target
        self.Date = Date
        self.Source = Source
        self.SourceLink = SourceLink
    }
}
