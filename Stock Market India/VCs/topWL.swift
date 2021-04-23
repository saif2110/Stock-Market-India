//
//  topWL.swift
//  Stock Market India
//
//  Created by Junaid Mukadam on 22/04/21.
//

import UIKit
import SwiftyJSON
import Alamofire

class topWL: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
            return WLclassArrayWinners.count
        }else{
            return WLclassArrayLosers.count
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let details:WLclass!
        
        if indexPath.section == 0 {
            details = WLclassArrayWinners[indexPath.row]
        }else{
            details = WLclassArrayLosers[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as! mycell
        cell.textLabel?.textColor = .darkGray
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14.5, weight: .semibold)
        cell.textLabel?.minimumScaleFactor = 0.5
        cell.textLabel?.clipsToBounds = true
        cell.textLabel?.text = details.companyName ?? ""
        
        
        cell.detailTextLabel?.textColor = .systemRed
        
        if String(Int(details.dayChange?.rounded() ?? 00)).contains("-"){
            
            let maketPrice = String(Int(details.marketPrice?.rounded() ?? 00))
            let dayChnage = String(Int(details.dayChange?.rounded() ?? 00))
            let att = NSMutableAttributedString(string:"Price: ₹" + maketPrice + "    " + "↓ ₹" + dayChnage)
            
            att.setColorForText(textForAttribute: "↓", withColor: .black)
            cell.detailTextLabel?.attributedText = att
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
            
        }else{
            
            let maketPrice = String(Int(details.marketPrice?.rounded() ?? 00))
            let dayChnage = String(Int(details.dayChange?.rounded() ?? 00))
            let att = NSMutableAttributedString(string:"Price: ₹" + maketPrice + "    " + "↑ ₹" + dayChnage)
            att.setColorForText(textForAttribute: "↑" , withColor: .systemGreen)
            cell.detailTextLabel?.attributedText = att
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        }
        
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return headerView(label: "Today's Winners")
            
        }else if  section == 1 {
            
            return headerView(label: "Today's Losers")
        }
        
        return headerView(label: "")
    }
    
    func headerView(label:String) -> UIView {
        let sectionHeader = UIView.init(frame: CGRect.init(x: 0, y: 0, width: myView.frame.width, height: 50))
        sectionHeader.backgroundColor = .white
        let sectionText = UILabel()
        sectionText.frame = CGRect.init(x: 10, y: 8, width: sectionHeader.frame.width-10, height: sectionHeader.frame.height-10)
        sectionText.text = label
        sectionText.font = .systemFont(ofSize: 16, weight: .bold) // my custom font
        sectionText.textColor = .darkGray
        sectionHeader.addSubview(sectionText)
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    @IBOutlet weak var myView: UITableView!
    
    var WLclassArrayWinners = [WLclass]()
    var WLclassArrayLosers = [WLclass]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showIntrest(Myself: self)
        postWithParameter(Url: "WinnerLosser.json", parameters: [:]) { (js, Err) in
            
            let json = JSON(js)
            
            for (_,Subjson) in json["exploreCompanies"]["TOP_GAINERS"] {
                self.WLclassArrayWinners.append(WLclass(companyName: Subjson["company"]["companyName"].string ?? "", marketPrice: Subjson["stats"]["ltp"].float ?? 0.10, dayChange: Subjson["stats"]["dayChange"].float ?? 0.10))
            }
            
            for (_,Subjson) in json["exploreCompanies"]["TOP_LOSERS"] {
                self.WLclassArrayLosers.append(WLclass(companyName: Subjson["company"]["companyName"].string ?? "", marketPrice: Subjson["stats"]["ltp"].float ?? 0.10, dayChange: Subjson["stats"]["dayChange"].float ?? 0.10))
            }
            
            
            self.myView.delegate = self
            self.myView.dataSource = self
            self.myView.reloadData()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    class WLclass {
        var companyName:String?
        var marketPrice:Float?
        var dayChange:Float?
        
        init(companyName:String,marketPrice:Float,dayChange:Float) {
            self.companyName = companyName
            self.marketPrice = marketPrice
            self.dayChange = dayChange
        }
    }
    
}
