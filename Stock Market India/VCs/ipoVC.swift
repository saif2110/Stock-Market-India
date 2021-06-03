//
//  ipoVC.swift
//  Stock Market India
//
//  Created by Junaid Mukadam on 29/03/21.
//

import UIKit
import SwiftyJSON

class ipoVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var openData = [DataOFjson]()
    var upcomingData = [DataOFjson]()
    var closedData = [DataOFjson]()
    
    var indicator = UIActivityIndicatorView()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return openData.count
        }else if section == 1 {
            return upcomingData.count
        }else{
            return closedData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IPOopen", for: indexPath) as! IPOopen
        if indexPath.section == 0 {
            cell.data = openData[indexPath.row]
            cell.ViewInfo.tag = indexPath.row
            cell.ViewInfo.isUserInteractionEnabled = true
            cell.ViewInfo.setTitleColor(.systemRed, for: .normal)
            cell.ViewInfo.addTarget(self, action: #selector(ViewInfoTapped), for: .touchUpInside)
        }else if indexPath.section == 1 {
            cell.data = upcomingData[indexPath.row]
            cell.ViewInfo.isUserInteractionEnabled = false
            cell.ViewInfo.setTitleColor(.lightGray, for: .normal)
        }else{
            cell.data = closedData[indexPath.row]
            cell.ViewInfo.isUserInteractionEnabled = false
            cell.ViewInfo.setTitleColor(.lightGray, for: .normal)
        }
        
        return cell
    }
    
    @objc func ViewInfoTapped(sender:UIButton) {
        
        if UserDefaults.standard.isProMember() {
            
            let MainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = MainStoryboard.instantiateViewController(withIdentifier: "ShouldYouBuy") as! ShouldYouBuy
            controller.openData = openData[sender.tag]
            self.present(controller, animated: true, completion: nil)
            
        }else{
            
            let vc = InAppVC()
            self.present(vc, animated: true, completion: nil)
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return headerView(label: "Open Now")
        }else if section == 1 {
            return headerView(label: "Upcoming")
        }else{
            return headerView(label: "Expired")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return footerView(label: "No Open IPO.\nPlease comeback for more updates")
        }else if section == 1 {
            return footerView(label: "No Upcoming IPO.\nPlease comeback for more updates")
        }else{
            return footerView(label: "No IPO is Expired.\nPlease comeback for more updates")
        }
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
    
    func footerView(label:String) -> UIView {
        let sectionHeader = UIView.init(frame: CGRect.init(x: 0, y: 0, width: myView.frame.width, height: 50))
        sectionHeader.backgroundColor = .white
        let sectionText = UILabel()
        sectionText.frame = CGRect.init(x: 10, y: 8, width: sectionHeader.frame.width-10, height: sectionHeader.frame.height-10)
        sectionText.text = label
        sectionText.font = .systemFont(ofSize: 13, weight: .medium)
        sectionText.textColor = .systemRed
        sectionText.textAlignment = .center
        sectionText.numberOfLines = 0
        sectionHeader.addSubview(sectionText)
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        195
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            if openData.count == 0 {
                return 50
            }else{
                return 0
            }
        }else if section == 1 {
            if upcomingData.count == 0 {
                return 50
            }else{
                return 0
            }
            
        }else{
            if closedData.count == 0 {
                return 50
            }else{
                return 0
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    @IBOutlet weak var myView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "IPO Guide"
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        indicator.color = .systemRed
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        indicator.startAnimating()
        
        postWithParameter(Url: "getIPO.php", parameters: [:]) { (Json, Err) in
            
            for (_,Subjson) in Json["CLOSED"] {
                self.closedData.append(DataOFjson(logoUrl: Subjson["logoUrl"].string ?? "Coming Soon", minPrice: Subjson["minPrice"].string ?? "Coming Soon", maxPrice: Subjson["maxPrice"].string ?? "Coming Soon", lotSize: Subjson["lotSize"].string ?? "Coming Soon", name: Subjson["name"].string ?? "Coming Soon", issueSize: Subjson["issueSize"].string ?? "Coming Soon", biddingEndDate: Subjson["biddingEndDate"].string ?? "Coming Soon", stars: Subjson["stars"].string ?? "2"))
            }
            
            for (_,Subjson) in Json["OPEN"] {
                self.openData.append(DataOFjson(logoUrl: Subjson["logoUrl"].string ?? "Coming Soon", minPrice: Subjson["minPrice"].string ?? "Coming Soon", maxPrice: Subjson["maxPrice"].string ?? "Coming Soon", lotSize: Subjson["lotSize"].string ?? "Coming Soon", name: Subjson["name"].string ?? "Coming Soon", issueSize: Subjson["issueSize"].string ?? "Coming Soon", biddingEndDate: Subjson["biddingEndDate"].string ?? "Coming Soon", stars: Subjson["stars"].string ?? "2"))
            }
            
            for (_,Subjson) in Json["UPCOMING"] {
                self.upcomingData.append(DataOFjson(logoUrl: Subjson["logoUrl"].string ?? "Coming Soon", minPrice: Subjson["minPrice"].string ?? "Coming Soon", maxPrice: Subjson["maxPrice"].string ?? "Coming Soon", lotSize: Subjson["lotSize"].string ?? "Coming Soon", name: Subjson["name"].string ?? "Coming Soon", issueSize: Subjson["issueSize"].string ?? "Coming Soon", biddingEndDate: Subjson["biddingEndDate"].string ?? "Coming Soon", stars: Subjson["stars"].string ?? "2"))
            }
            
            
            self.indicator.stopAnimating()
            
            self.myView.delegate = self
            self.myView.dataSource = self
            self.myView.reloadData()
            
        }
    }
}

class DataOFjson {
    
    var logoUrl:String?
    var minPrice:String?
    var maxPrice:String?
    var lotSize:String?
    var name:String?
    var issueSize:String?
    var biddingEndDate:String?
    var stars:String?
    
    init(logoUrl:String,minPrice:String,maxPrice:String,lotSize:String,name:String,issueSize:String,biddingEndDate:String,stars:String) {
        self.logoUrl = logoUrl
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.lotSize = lotSize
        self.name = name
        self.issueSize = issueSize
        self.biddingEndDate = biddingEndDate
        self.stars = stars
    }
}
