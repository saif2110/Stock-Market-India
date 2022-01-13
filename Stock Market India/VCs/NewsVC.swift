//
//  NewsVC.swift
//  Stock Market India
//
//  Created by Saif on 07/01/22.
//

import UIKit
import Alamofire
import SwiftyJSON
import SafariServices

class NewsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let fetchedData = newsdata[indexPath.row]
        
        cell.title.text = fetchedData.title
        cell.decription.text = fetchedData.summary
        cell.date.text = covertdDate(isoDate: fetchedData.pubDate ?? "")
        
        if fetchedData.imageURL == "" {
            cell.imgView.image = UIImage(named: "newsicon")
        }else{
            cell.imgView.kf.setImage(with: URL(string: fetchedData.imageURL ?? ""))
        }
        
        return cell
    }
    

    @IBOutlet weak var myView: UITableView!
    
    var newsdata = [NewsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        postWithParameter(Url: "news.json", parameters: [:]) { (js, Err) in
            
            if js.exists() {
                
                for (_,Subjson) in js["results"] {
                    let raw = Subjson
                    if raw["source"] != "Groww"{
                        print(raw["imageURL"].string ?? "")
                    self.newsdata.append(NewsData(id: raw["id"].string ?? "", title: raw["title"].string ?? "", url: raw["url"].string ?? "", imageURL: raw["imageUrl"].string ?? "", source: raw["source"].string ?? "", summary: raw["summary"].string ?? "", pubDate: raw["pubDate"].string ?? ""))
                    }
                    
                    print(raw["imageUrl"].string ?? "")
                }
            }
        
           
            self.myView.delegate = self
            self.myView.dataSource = self
            self.myView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let url = URL(string: newsdata[indexPath.row].url ?? ""){
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
        
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    func covertdDate(isoDate:String) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
        let date = dateFormatter.date(from: isoDate)
        
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "dd-MM-yyyy"
        
        return convertDateFormatter.string(from: date!)
    }

}


class NewsData {
    let id, title: String?
    let url: String?
    let imageURL: String?
    let source: String?
    let summary, pubDate: String?

    init(id: String?, title: String?, url: String?, imageURL: String?, source: String?, summary: String?, pubDate: String?) {
        self.id = id
        self.title = title
        self.url = url
        self.imageURL = imageURL
        self.source = source
        self.summary = summary
        self.pubDate = pubDate
    }
}
