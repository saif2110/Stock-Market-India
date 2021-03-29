//
//  searchVC.swift
//  Stock Market India
//
//  Created by Junaid Mukadam on 10/12/20.
//

import UIKit

class searchVC: UIViewController,UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate {
    
    
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
        
        return cell
    }
    
    @objc func TapLike(sender:UIButton){
        if UserDefaults.standard.isLogin(){
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
        if UserDefaults.standard.isLogin(){
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
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        postWithParameter(Url: "searchPreStock.php", parameters: ["Query":searchText]) { (json, err) in
            if err == nil {
                
                self.nameofStock.removeAll()
                self.date.removeAll()
                self.currentPrice.removeAll()
                self.target.removeAll()
                self.period.removeAll()
                self.SL.removeAll()
            
                
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
                
                
            }else{
                self.nameofStock.removeAll()
                self.date.removeAll()
                self.currentPrice.removeAll()
                self.target.removeAll()
                self.period.removeAll()
                self.SL.removeAll()
                
                self.myView.delegate = self
                self.myView.dataSource = self
                self.myView.reloadData()
                
            }
        }
        
    }
    
    @IBOutlet weak var myView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        DispatchQueue.main.async {
            self.searchBar.becomeFirstResponder()
        }
        myView.delegate = self
        myView.dataSource = self
        myView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if nameofStock.count > 0 {
            return 1
        }else{
            TableViewHelper.EmptyMessage(message: "Search stock you looking for.\nIf you not able to find any stock please try different.", viewController: myView)
            return 0
        }
        
    }
    
    
}
//https://safeapps.online/StockMarket/searchPreStock.php
