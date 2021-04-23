//
//  fifty&LW.swift
//  Stock Market India
//
//  Created by Junaid Mukadam on 21/04/21.
//

import UIKit
import SwiftyJSON
import Alamofire

class niftyFifty: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nifty.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as! mycell
        let details = nifty[indexPath.row]
        cell.textLabel?.textColor = .darkGray
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14.5, weight: .semibold)
        cell.textLabel?.minimumScaleFactor = 0.5
        cell.textLabel?.clipsToBounds = true
        cell.textLabel?.text = details.companyName ?? ""
        
        
        cell.detailTextLabel?.textColor = .systemRed
        
        if String(Int(details.dayChange?.rounded() ?? 00)).contains("-"){
            
            let att = NSMutableAttributedString(string:"Price: ₹" + String(Int(details.marketPrice?.rounded() ?? 00)) + "    " + "↓ ₹" + String(Int(details.dayChange?.rounded() ?? 00)))
            
            att.setColorForText(textForAttribute: "↓", withColor: .black)
            cell.detailTextLabel?.attributedText = att
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
            
        }else{
            let att = NSMutableAttributedString(string:"Price: ₹" + String(Int(details.marketPrice?.rounded() ?? 00)) + "    " + "↑ ₹" + String(Int(details.dayChange?.rounded() ?? 00)))
            att.setColorForText(textForAttribute: "↑" , withColor: .systemGreen)
            cell.detailTextLabel?.attributedText = att
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        }
        
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details = nifty[indexPath.row]
        let MainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = (MainStoryboard.instantiateViewController(withIdentifier: "searchVC") as? searchVC)
        controller?.goforSearch = details.companyName ?? ""
        self.present(controller!, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var myView: UITableView!
    
    var nifty = [nifty50]()
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showIntrest(Myself: self)
        
        postWithParameter(Url: "nifty50.json", parameters: [:]) { (js, Err) in
            
            let json = JSON(js)
            
            for (_,Subjson) in json["stocksPeerComparisionDtos"] {
                self.nifty.append(nifty50(companyName: Subjson["companyName"].string ?? "", marketPrice: Subjson["marketPrice"].float ?? 0.10, dayChange: Subjson["dayChange"].float ?? 0.10, industryName: Subjson["industryName"].string ?? ""))
            }
            
            self.myView.delegate = self
            self.myView.dataSource = self
            self.myView.reloadData()
        }
        
    }
    
    
}


class nifty50 {
    var companyName:String?
    var marketPrice:Float?
    var dayChange:Float?
    var industryName:String?
    
    init(companyName:String,marketPrice:Float,dayChange:Float,industryName:String) {
        self.companyName = companyName
        self.marketPrice = marketPrice
        self.dayChange = dayChange
        self.industryName = industryName
    }
}

extension NSMutableAttributedString {
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
}
