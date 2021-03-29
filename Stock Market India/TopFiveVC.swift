//
//  TopFiveVC.swift
//  Stock Market India
//
//  Created by Junaid Mukadam on 25/03/21.
//

import UIKit
import GoogleMobileAds

class TopFiveVC: UIViewController,UITableViewDelegate,UITableViewDataSource,GADFullScreenContentDelegate {
    
    var rewardedAd: GADRewardedAd?
    var indicator = UIActivityIndicatorView()
    
    func loadRewardedAd() {
        indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        indicator.color = .systemRed
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        indicator.startAnimating()
        
        let request = GADRequest()
        GADRewardedAd.load(
            withAdUnitID: videoads,
            request: request,
            completionHandler: { ad, error in
                if error != nil {
                    self.indicator.stopAnimating()
                    self.present(myAlt(titel:"No Ad Found",message:"Something went wrong.Ad is not found this time.Please try again later."), animated: true, completion: nil)
                    return
                }
                self.rewardedAd = ad
                self.indicator.stopAnimating()
                self.show()
            })
    }
    
    func show() {
        if rewardedAd != nil {
            rewardedAd!.present(
                fromRootViewController: self,
                userDidEarnRewardHandler: {
                    self.watchAdviewTohide.isHidden = true
                })
        } else {
            self.indicator.stopAnimating()
        }
    }
    
    @IBOutlet weak var watchAdView: UIView!
    @IBOutlet weak var watchAdLabel: UILabel!
    @IBOutlet weak var watchAdbutout: UIButton!
    @IBOutlet weak var watchAdviewTohide: UIView!
    @IBAction func watchAdbut(_ sender: Any) {
        loadRewardedAd()
    }
    
    
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
        
        return cell
    }
    
    @objc func TapLike(sender:UIButton){
        requestToRate()
        if !UserDefaults.standard.isLogin(){
            self.present(myAlt(titel:"You need to Sign In",message:"You need to sign in to Like, Dislike & Post Tips"), animated: true, completion: nil)
        }else{
            let currentTimeInMiliseconds = Date().timeIntervalSince1970 * 1000
            if currentTimeInMiliseconds > UserDefaults.standard.getLikeDisLikeTime() + 3600000 {
                Likes[sender.tag] = String(Int(Likes[sender.tag])! + 1)
                myView.reloadData()
                UserDefaults.standard.setLikeDisLikeTime(value: currentTimeInMiliseconds)
                
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
    
    var nameofStock = [String]()
    var date = [String]()
    var currentPrice = [String]()
    var target = [String]()
    var period = [String]()
    var SL = [String]()
    var Likes = [String]()
    var DisLikes = [String]()
    
    @IBOutlet weak var myView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Top 5 Stocks"
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = leftBarButtonItemStored
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.topItem?.title = "Top 5 Stocks"
        
        watchAdView.layer.cornerRadius = 10
        watchAdView.shadow2()
        
        watchAdbutout.layer.cornerRadius = 10
        watchAdbutout.shadow2()
        
        watchAdLabel.text = "We have chosen today's top 5 stocks for you that are posted frequently by other users.\n\nStocks will be updated every 24 hrs."
        getStockData()
    }
    
    func getStockData() {
        
        postWithParameter(Url: "getTopStocks.php", parameters: [:]) { (json, err) in
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
                
                self.myView.delegate = self
                self.myView.dataSource = self
                self.myView.reloadData()
            }
        }
    }
}
