//
//  ShouldYouBuy.swift
//  Stock Market India
//
//  Created by Junaid Mukadam on 30/03/21.
//

import Alamofire
import SwiftyJSON
import UIKit

class ShouldYouBuy: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var openData:DataOFjson?
    
    @IBOutlet weak var pros: UILabel!
    @IBOutlet weak var cons: UILabel!
    @IBOutlet weak var remark: UILabel!
    @IBOutlet weak var VideoLink: UIButton!
    var VideoLinkText = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IPOopen", for: indexPath) as! IPOopen
        cell.data = openData
        return cell
    }
    
    @IBOutlet weak var myView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showIntrest(Myself: self, Wait: 1.5)
        
        postWithParameter(Url: "ipoConsPros.json", parameters: [:]) { (JSON, Err) in
            self.pros.text =  JSON[self.openData?.name ?? ""]["pros"].string ?? ""
            
            self.cons.text =  JSON[self.openData?.name ?? ""]["cons"].string ?? ""
            
            self.remark.text =  JSON[self.openData?.name ?? ""]["Remark"].string ?? ""
            
            self.remark.text =  JSON[self.openData?.name ?? ""]["Remark"].string ?? ""
            
            self.VideoLinkText =  JSON[self.openData?.name ?? ""]["VideoLink"].string ?? ""
            
            self.myView.dataSource = self
            self.myView.delegate = self
            self.myView.reloadData()
        }
    }
    
    @IBAction func videoBut(_ sender: Any) {
        UIApplication.shared.open(URL(string:VideoLinkText)!)
    }
    
    @IBAction func rateUs(_ sender: Any) {
        UIApplication.shared.open(URL(string:"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1546123296&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software")!)
    }
    
    @IBAction func feedback(_ sender: Any) {
        UIApplication.shared.open(createEmailUrl(to:"feedback@safeapps.online", subject: "Feedback", body: "")!)
    }
    
    @IBAction func share(_ sender: Any) {
        let text = "*Stock Market India*\n \nDownload this app get best stock tips and suggestions from experts.\n \n Link to download - https://apps.apple.com/in/app/stock-market-india/id1546123296"
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}
