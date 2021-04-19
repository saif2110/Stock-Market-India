//
//  ViewController.swift
//  Stock Market India
//
//  Created by Junaid Mukadam on 06/12/20.
//

import UIKit
import Alamofire
import SwiftyJSON
import AppTrackingTransparency
import AdSupport
import GoogleMobileAds



class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var bannerView: GADBannerView!
    
    var nameofStock = [String]()
    var date = [String]()
    var currentPrice = [String]()
    var target = [String]()
    var period = [String]()
    var SL = [String]()
    var Likes = [String]()
    var DisLikes = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nameofStock.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! mainCell
        cell.nameStock.text = nameofStock[indexPath.row].capitalized
        cell.Date.text = date[indexPath.row]
        cell.CurrentPrice.text = "Current Price: " + currentPrice[indexPath.row]
        cell.SellTarget.text = "Sell Target: " + target[indexPath.row]
        cell.Period.text = "Period: " + period[indexPath.row]
        cell.StopLoss.text = "Stop Loss: " + SL[indexPath.row]
        cell.OutsideView.shadow()
        
        cell.Like.tag = indexPath.row
        cell.DisLike.tag = indexPath.row
        cell.Like.addTarget(self, action: #selector(TapLike), for: .touchUpInside)
        cell.DisLike.addTarget(self, action: #selector(TapDisLike), for: .touchUpInside)
        cell.Like.setTitle("+"+Likes[indexPath.row], for: .normal)
        cell.DisLike.setTitle("-"+DisLikes[indexPath.row], for: .normal)
        
        if indexPath.row == 4{
            cell.adView.isHidden = false
            cell.adView.rootViewController = self
            cell.adView.load(GADRequest())
        }else{
            cell.adView.isHidden = true
        }
        
        return cell
    }
    
    @objc func TapLike(sender:UIButton){
        if !UserDefaults.standard.isLogin(){
            self.present(myAlt(titel:"You need to Sign In",message:"You need to sign in to Like, Dislike & Post Tips"), animated: true, completion: nil)
        }else{
            let currentTimeInMiliseconds = Date().timeIntervalSince1970 * 1000
            if currentTimeInMiliseconds > UserDefaults.standard.getLikeDisLikeTime() + 3600000 {
                Likes[sender.tag] = String(Int(Likes[sender.tag])! + 1)
                myView.reloadData()
                UserDefaults.standard.setLikeDisLikeTime(value: currentTimeInMiliseconds)
                requestToRate()
            }else{
                self.present(myAlt(titel:"Limit Exceeded",message:"You can Like or Dislike only one stock every 1 hour"), animated: true, completion: nil)
            }
        }
    }
    
    @objc func TapDisLike(sender:UIButton){
        if !UserDefaults.standard.isLogin(){
            self.present(myAlt(titel:"You need to Sign In",message:"You need to sign in to Like, Dislike & Post Tips"), animated: true, completion: nil)
        }else{
            let currentTimeInMiliseconds = Date().timeIntervalSince1970 * 1000
            if currentTimeInMiliseconds > UserDefaults.standard.getLikeDisLikeTime() + 3600000 {
                DisLikes[sender.tag] = String(Int(DisLikes[sender.tag])! + 1)
                myView.reloadData()
                UserDefaults.standard.setLikeDisLikeTime(value: currentTimeInMiliseconds)
            }else{
                self.present(myAlt(titel:"Limit Exceeded",message:"You can Like or Dislike only one stock every 1 hour"), animated: true, completion: nil)
            }
        }
    }
    
    @objc func addTapped(){
        let MainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = (MainStoryboard.instantiateViewController(withIdentifier: "searchVC") as? searchVC)
        self.present(controller!, animated: true, completion: nil)
    }
    
    @objc func sort(sender:UIButton) {
        
        if sender.currentTitle == " All Stocks" {
            sender.setTitle(" Intraday", for: .normal)
            getStockData(sort: "Intraday")
            Sender = "Intraday"
        }else if sender.currentTitle == " Intraday"{
            sender.setTitle(" 1 Week", for: .normal)
            getStockData(sort: "1 Week")
            Sender = "1 Week"
        }else if sender.currentTitle == " 1 Week"{
            sender.setTitle(" 1 Month", for: .normal)
            getStockData(sort: "1 Month")
            Sender = "1 Month"
        }else if sender.currentTitle == " 1 Month"{
            sender.setTitle(" 6 Months", for: .normal)
            getStockData(sort: "6 Months")
            Sender = "6 Months"
        }else if sender.currentTitle == " 6 Months"{
            sender.setTitle(" All Stocks", for: .normal)
            getStockData()
            Sender = ""
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("sortData"), object: nil)
        
    }
    
    @IBOutlet weak var myView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Live 10 Stocks"
    }
    
    var indicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.getnumberOftimeAppOpen() > 8 {
            requestToRate()
        }
        
        indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        indicator.color = .systemRed
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        indicator.startAnimating()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationController?.navigationBar.tintColor = .red
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem =  UIBarButtonItem(image: #imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(addTapped))
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up.arrow.down.circle"), for: .normal)
        button.setTitle(" All Stocks", for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(sort), for: .touchUpInside)
        button.titleLabel?.minimumScaleFactor = 0.5
        button.clipsToBounds = true
        
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        leftBarButtonItemStored = self.navigationController?.navigationBar.topItem?.leftBarButtonItem
        
        getStockData(sort: "")
        
        showIntrest(Myself: self)
        
    }
    
    
    func getStockData(sort:String = "") {
        indicator.startAnimating()
        postWithParameter(Url: "getStockdata.php", parameters: ["limit":11,"sort":sort]) { (json, err) in
            if err == nil {
                
                self.nameofStock.removeAll()
                self.date.removeAll()
                self.currentPrice.removeAll()
                self.target.removeAll()
                self.period.removeAll()
                self.SL.removeAll()
                self.Likes.removeAll()
                self.DisLikes.removeAll()
                
                for (_,SubJson) in json {
                    self.nameofStock.append(SubJson["Name"].string ?? "Null")
                    self.date.append(SubJson["PostedTime"].string ?? "Null")
                    self.currentPrice.append(SubJson["Rate"].string ?? "Null")
                    self.target.append(SubJson["Target"].string ?? "Null")
                    self.period.append(SubJson["HoldingTime"].string ?? "Null")
                    self.SL.append(SubJson["SL"].string ?? "Null")
                    
                    self.Likes.append(LikeAlgoritham(Name: SubJson["Name"].string ?? "Null", Date: SubJson["PostedTime"].string ?? "Null"))
                    self.DisLikes.append(DisLikeAlgoritham(Name: SubJson["Name"].string ?? "Null", Date: SubJson["PostedTime"].string ?? "Null"))
                }
                
                self.indicator.stopAnimating()
                self.myView.delegate = self
                self.myView.dataSource = self
                self.myView.reloadData()
            }else{
                self.indicator.stopAnimating()
            }
        }
    }
    
}

extension UIView {
    
    func shadow()  {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
    }
    
    func shadow2()  {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
    }
}


